# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

import itertools
import random

from odoo import models, _
from odoo.exceptions import UserError

import base64
import pandas as pd

import json
import re

import tempfile
import requests
from datetime import datetime

PERIOD_REGEX=re.compile(r'^\s*(\d+\.\d+\.\d+)\s*[- ]\s*(\d+\.\d+\.\d+).*$')

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
            # moguća je lista odgovora
            answers = self._get_answer(record, body, values, command)
            message_type = 'comment'
            subtype_id = self.env['ir.model.data']._xmlid_to_res_id('mail.mt_comment')
            if not isinstance(answers, list):
                answers = [ answers ]

            for answer in answers:    
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
                return _("Trebate izvještaj? Odlično. Molim navedite koji, npr: <span class=\"o_odoobot_command\">isplate</span>,<span class=\"o_odoobot_command\">bruto detaširani</span>,<span class=\"o_odoobot_command\">svi</span>   ")
            else:

                if odoobot_state == 'xlsx':
                    if self._is_xlsx_rpt_1_requested(body):
                        self.env.user.odoobot_state = "xlsx_rpt1"
                        self.env.user.odoobot_failed = False
                        return _("unesite period u formatu DD.MM.GG-DD.MM.GG npr: <span class=\"o_odoobot_command\">10.01.24-31.12.24</span>"
                             )
                    elif self._is_xlsx_rpt_2_requested(body):
                        self.env.user.odoobot_state = "xlsx_rpt2"
                        self.env.user.odoobot_failed = False
                        return _("unesite period u formatu DD.MM.GG-DD.MM.GG npr: <span class=\"o_odoobot_command\">10.01.24-31.12.24</span>"
                                )
                    
                    elif self._is_xlsx_rpt_svi_requested(body):
                        self.env.user.odoobot_state = "xlsx_svi"
                        self.env.user.odoobot_failed = False
                        return _("unesite period u formatu DD.MM.GG-DD.MM.GG npr: <span class=\"o_odoobot_command\">10.01.24-31.12.24</span>"
                             )
                
                elif odoobot_state == "xlsx_rpt1":
                    self.env.user.odoobot_state = 'idle'
                    self.env.user.odoobot_failed = True
                   
                    url="https://postgrest-odoo-fuelboss-1.api.out.ba/rpc/rpt_%s"
                    rpt_name = "isplate_banke"
                    
                    return self._run_report(rpt_names=[rpt_name], 
                        url=url,
                        json_data=self._get_json_dat_period(body)
                    )

                elif odoobot_state == "xlsx_rpt2":
                    self.env.user.odoobot_state = 'idle'
                    self.env.user.odoobot_failed = True
                    #period = body
                    url="https://postgrest-odoo-fuelboss-1.api.out.ba/rpc/rpt_%s"
                    rpt_name = "bruto_detasirani"
                    
                    return self._run_report(rpt_names=[rpt_name], 
                        url=url,
                        json_data=self._get_json_dat_period(body)
                    )
          
                    #return _("evo link na rpt1: za period: " + body + "<br/>" +
                    #         "<span class=\"o_odoobot_command\"><a href=\"http://test.bring.out.ba/roles_example\" target=\"_blank\">Report isplate</a></span>"
                    #         )

                elif odoobot_state == "xlsx_svi":
                    self.env.user.odoobot_state = 'idle'
                    self.env.user.odoobot_failed = True
                    #period = body
                    url="https://postgrest-odoo-fuelboss-1.api.out.ba/rpc/rpt_%s"
                    rpt_names = [ "isplate_banke", "bruto_detasirani" ]
                   
                    return self._run_report(rpt_names=rpt_names, 
                        url=url,
                        json_data=self._get_json_dat_period(body)
                    )
          
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

    def _is_xlsx_rpt_2_requested(self, body):
        """da li korisnik traži excel report rpt2
        """
        return any(token in body for token in ['rpt2', 'bruto detasirni', 'bruto detaširani', "brutod", "detaširani"])
    
    def _is_xlsx_rpt_svi_requested(self, body):
        return any(token in body for token in ['svi', 'daj mi sve izvještaje'])
    

    def _is_xlsx_requested(self, body):
        """da li korisnik traži excel report
        """
        return any(token in body for token in ['xlsx', 'excel', 'libreoffice', _('xlsx')])


    def _get_json_dat_period(self, body):      
        dDatOd = datetime.now()
        dDatDo = datetime.now()
        try:
            dat_od, dat_do = PERIOD_REGEX.match(body).groups()
            dDatOd = datetime.strptime(dat_od, '%d.%m.%y')
            dDatDo = datetime.strptime(dat_do, '%d.%m.%y')
        except:
            raise UserError("format datumskog perioda nije dobro naveden")
        
        return {
            "dat_od": dDatOd.strftime('%Y-%m-%d'),
            "dat_do": dDatDo.strftime('%Y-%m-%d')
        }
    
    def _run_report(self, rpt_names=["isplate_banke"], 
                    url="https://postgrest-odoo-fuelboss-1.api.out.ba/rpc/rpt_%s",
                    json_data={
                        "dat_od": "2024-09-01",
                        "dat_do": "2024-09-30"
                    }):
      
        ret = []
        for rpt_name in rpt_names:

            _url = url % (rpt_name)
            headers = {
                "Authorization": "Bearer %s" % self.env.user.oauth_access_token,
                "Content-type": "application/json",
                "accept": "application/json"
            }
            
            # https://stackoverflow.com/questions/42518864/convert-json-data-from-request-into-pandas-dataframe
            response = requests.post(url=_url, json=json_data, headers=headers)

            if response.status_code == 200:
                df = pd.DataFrame.from_dict(response.json())
                temp_f = tempfile.NamedTemporaryFile(suffix='.xlsx')
                df.to_excel(temp_f.name, index=False)

                fh = open(temp_f.name, "r")
                content = fh.buffer.read()
                fh.close()
                
                attachment = self.env['ir.attachment'].create({
                    'type': 'binary',
                    'name': 'rpt_%s_%s_%s.xlsx' %  (rpt_name, json_data["dat_od"], json_data["dat_do"]),   #invoice_date.strftime('%Y-%m'),
                    'res_model': 'mail.compose.message',
                    'datas': base64.encodebytes(content),
                })

                ret.append({
                    "attachment": attachment,
                    "content": "u prilogu izvještaj"
                })
            else:
                if response.status_code == 404:
                    details = (json.loads(response.text))["details"]
                else:
                    details = "nepoznato"
                ret.append(_("Greška! (detaljno: %s)" % details))

        return ret    