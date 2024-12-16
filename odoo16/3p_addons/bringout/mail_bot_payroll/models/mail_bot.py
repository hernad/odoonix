# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

import itertools
import random

from odoo import models, _

import base64
import pandas as pd

import json

import tempfile
import requests


class MailBot(models.AbstractModel):
    _inherit = 'mail.bot'
    _description = 'Mail Bot Payroll'

    def _apply_logic(self, record, values, command=None):
        """ Apply bot logic to generate an answer (or not) for the user
        The logic will only be applied if odoobot is in a chat with a user or
        if someone pinged odoobot.
    
         :param record: the mail_thread (or mail_channel) where the user
            message was posted/odoobot will answer.
         :param values: msg_values of the message_post or other values needed by logic
         :param command: the name of the called command if the logic is not triggered by a message_post
        """
    
        odoobot_id = self.env['ir.model.data']._xmlid_to_res_id("base.partner_root")
        if len(record) != 1 or values.get("author_id") == odoobot_id or values.get("message_type") != "comment" and not command:
            return
        if self._is_bot_pinged(values) or self._is_bot_in_private_channel(record):
            body = values.get("body", "").replace(u'\xa0', u' ').strip().lower().strip(".!")
            answer = self._get_answer(record, body, values, command)
            message_type = 'comment'
            subtype_id = self.env['ir.model.data']._xmlid_to_res_id('mail.mt_comment')
            if isinstance(answer, dict):
                attachment = answer.get("attachment")
                content = answer.get("content")
                record.with_context(mail_create_nosubscribe=True).sudo().message_post(
                                body=content,
                                attachment_ids=[attachment.id],
                                author_id=odoobot_id, 
                                message_type=message_type,
                                subtype_id=subtype_id)

            elif answer:
                record.with_context(mail_create_nosubscribe=True).sudo().message_post(body=answer, author_id=odoobot_id, message_type=message_type, subtype_id=subtype_id)

    def _get_answer(self, record, body, values, command=False):

        # onboarding
        odoobot_state = self.env.user.odoobot_state
        if self._is_bot_in_private_channel(record):
            # main flow
            if self._is_xlsx_requested(body): #and odoobot_state == 'idle'
                self.env.user.odoobot_state = "xlsx"
                self.env.user.odoobot_failed = False
                return _("Trebate neki izvjestaj? Odlično. Molim navedite koji, npr: <span class=\"o_odoobot_command\">isplate</span> ")
            else:
                # repeat question
                if odoobot_state == 'xlsx' and self._is_xlsx_rpt_1_requested(body):
                    self.env.user.odoobot_state = "xlsx_rpt1"
                    self.env.user.odoobot_failed = False
                    return _("unesite period u formatu DD.MM.GG-DD.MM.GG npr: <span class=\"o_odoobot_command\">10.01.24-31.12.24</span>"
                             )
                elif odoobot_state == "xlsx_rpt1":
                    self.env.user.odoobot_state = 'idle'
                    self.env.user.odoobot_failed = True
                    period = body

                   #curl -X 'GET' \
                   #'https://postgrest-odoo-fuelboss-1.api.out.ba:443/rpc/rpt_isplate_banke?dat_od=2024-09-01&dat_do=2024-09-30' \
                   #-H 'accept: application/json'


                   #curl -X 'GET' \
                   #'https://postgrest-odoo-fuelboss-1.api.out.ba:443/rpc/rpt_isplate_banke?dat_od=2024-09-01&dat_do=2024-09-30' \
                   # -H 'accept: application/json'

                
                    #print(self.env.user.name, self.env.user.oauth_access_token)

                    endpoint = "https://postgrest-odoo-fuelboss-1.api.out.ba/rpc/rpt_isplate_banke"
                    headers = {
                        "Authorization": "Bearer %s" % self.env.user.oauth_access_token,
                        "Content-type": "application/json",
                        "accept": "application/json"
                    }
                    data = {
                        "dat_od": "2024-09-01",
                        "dat_do": "2024-09-30"
                    }
                
                    # https://stackoverflow.com/questions/42518864/convert-json-data-from-request-into-pandas-dataframe
                    response = requests.post(endpoint, json=data, headers=headers)

                    #print(response.status_code)
                    #print(response.content)

                    df = pd.DataFrame.from_dict(response.json())
                    temp_f = tempfile.NamedTemporaryFile(suffix='.xlsx')
                    df.to_excel(temp_f.name, index=False)

                    fh = open(temp_f.name, "r")
                    content = fh.buffer.read()
                    fh.close()
                    
                    attachment = self.env['ir.attachment'].create({
                       'type': 'binary',
                       'name': 'isplate_%s_%s.xlsx' %  (data["dat_od"], data["dat_do"]),   #invoice_date.strftime('%Y-%m'),
                       'res_model': 'mail.compose.message',
                       'datas': base64.encodebytes(content),
                    })

                    


                    return {
                        "attachment": attachment,
                        "content": "u prilogu izvještaj"
                    }
                    
                    #return _("evo link na rpt1: za period: " + body + "<br/>" +
                    #         "<span class=\"o_odoobot_command\"><a href=\"http://test.bring.out.ba/roles_example\" target=\"_blank\">Report isplate</a></span>"
                    #         )


                #return random.choice([
                #    _("I'm not smart enough to answer your question.<br/>To follow my guide, ask: <span class=\"o_odoobot_command\">start the tour</span>."),
                #    _("Hmmm..."),
                #    _("I'm afraid I don't understand. Sorry!"),
                #    _("Sorry I'm sleepy. Or not! Maybe I'm just trying to hide my unawareness of human language...<br/>I can show you features if you write: <span class=\"o_odoobot_command\">start the tour</span>.")
                #])

                self.env.user.odoobot_state = 'idle'
                return super()._get_answer(record, body, values, command)
        return False


    def _is_xlsx_rpt_1_requested(self, body):
        """da li korisnik traži excel report rpt1
        """
        return any(token in body for token in ['rpt1', 'Report 1', 'Isplate', "isplate", "ISPLATE"])

  
    def _is_xlsx_requested(self, body):
        """da li korisnik traži excel report
        """
        return any(token in body for token in ['xlsx', 'excel', 'libreoffice', _('xlsx')])
