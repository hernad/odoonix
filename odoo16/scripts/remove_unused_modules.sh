#!/usr/bin/env bash

#MODULES="odoo_payroll_oca/payroll_account"
#MODULES+=" odoo_payroll_oca/payroll_contract_advantages"

ODOO_ADDONS_ROOT="odoo/addons"

ACCOUNT=on
PRODUCT=on
PORTAL=on
STOCK=on
SALE=on
DELIVERY=on
PURCHASE=on
MRP=on

POS=on
CRM=on

EVENT=on

HW=on
PAYMENT=off
SMS=off

WEBSITE=on

L10N=off
IAP=off
GAMIFICATION=on
FLEET=on
IM_LIVECHAT=on
HR=on

REPAIR=on
MAINTENANCE=on

MICROSOFT=off
GOOGLE=on

THEME=off
TEST=off

SPREADSHEET=on
MASS_MAILING=on

SOCIAL_MEDIA=on
SURVEY=on
LUNCH=on


if [[ $MRP == "off" ]] ; then
    echo ================ remove MRP ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_account"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_landed_costs"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_product_expiry"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_repair"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_subcontracting"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_subcontracting_account"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_subcontracting_dropshipping"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_subcontracting_purchase"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_subcontracting_repair"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mrp_subonctracting_landed_costs"
fi

if [[ $MICROSOFT == "off" ]] ; then
    echo ================ remove MICROSOFT ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/microsoft_account"
    MODULES+=" ${ODOO_ADDONS_ROOT}/microsoft_calendar"
    MODULES+=" ${ODOO_ADDONS_ROOT}/microsoft_outlook"
fi

if [[ $SALE == "off" ]] ; then
    echo ================ remove SALE ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_crm"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_expense"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_expense_margin"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_loyalty"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_loyalty_delivery"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_management"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_margin"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_mrp"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_mrp_margin"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_product_configurator"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_product_matrix"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_project"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_project_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_purchase"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_purchase_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_quotation_builder"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_sms"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sales_team"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_stock_margin"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sale_timesheet"
fi

if [[ $L10N == "off" ]] ; then
    echo ================ remove L10N ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_account_edi_ubl_cii_tests"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ae"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ae_pos"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ar"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ar_website_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_at"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_au"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_be"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_be_pos_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_bg"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_bo"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_br"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ca"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ch"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_cl"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_cn"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_cn_city"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_co"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_co_pos"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_cr"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_cz"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_de"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_de_skr03"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_de_skr04"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_din5008"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_din5008_purchase"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_din5008_repair"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_din5008_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_din5008_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_dk"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_do"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_dz"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ec"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ee"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_eg"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_eg_edi_eta"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_es"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_es_edi_sii"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_es_edi_tbai"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_et"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_eu_oss"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_fi"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_fi_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_fr"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_fr_facturx_chorus_pro"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_fr_fec"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_fr_pos_cert"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_gcc_invoice"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_gcc_invoice_stock_account"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_gcc_pos"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_generic_coa"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_gr"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_gt"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_hk"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_hn"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_hr"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_hr_euro"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_hu"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_id"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_id_efaktur"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ie"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_il"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_edi"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_edi_ewaybill"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_pos"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_purchase"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_purchase_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_sale_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_tcs_tds"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_in_upi"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_it"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_it_edi"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_it_edi_pa"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_it_edi_withholding"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_it_stock_ddt"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_jp"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ke"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ke_edi_tremol"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_latam_account_sequence"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_latam_base"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_latam_check"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_latam_invoice_document"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_lt"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_lu"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_lu_peppol_id"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_lv"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ma"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_mn"
    #MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_multilang"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_mx"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_mx_hr"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_my"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_mz"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_nl"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_no"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_nz"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_pa"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_pe"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ph"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_pk"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_pl"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_pl_jpk"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_pl_sale_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_pt"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ro"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_rs"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_sa"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_sa_edi"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_sa_edi_pos"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_sa_pos"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_se"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_sg"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_si"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_sk"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_syscohada"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_th"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_tr"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_tw"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ua"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_uk"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_uy"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ve"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_vn"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_za"

    #l10n_multilang
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_us"

    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ar_pos"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ar_withholding"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_br_sales"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_br_website_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_dk_bookkeeping"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_dk_oioubl"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_es_edi_facturae"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_es_edi_facturae_adm_centers"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_es_edi_facturae_invoice_period"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_es_pos"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_fr_hr_holidays"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_fr_hr_work_entry_holidays"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_hr_kuna"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_it_edi_website_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_jp_ubl_pint"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_kz"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_pe_pos"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_pe_website_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ro_edi"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_tn"
    MODULES+=" ${ODOO_ADDONS_ROOT}/l10n_ug"

fi

if [[ "$TEST" == "off" ]] ; then
    echo ================ remove TEST ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_access_rights"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_action_bindings"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_apikeys"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_assetsbundle"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_auth_custom"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_base_automation"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_convert"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_converter"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_crm_full"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_data_module"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_data_module_install"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_discuss_full"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_event_full"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_exceptions"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_http"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_impex"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_inherit"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_inherit_depends"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_inherits"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_inherits_depends"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_limits"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_lint"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_mail"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_mail_full"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_mail_sms"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_main_flows"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_mass_mailing"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_mimetypes"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_new_api"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_performance"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_populate"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_read_group"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_resource"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_rpc"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_sale_product_configurators"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_search_panel"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_testing_utilities"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_themes"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_translation_import"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_uninstall"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_website"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_website_modules"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_website_slides_full"
    MODULES+=" ${ODOO_ADDONS_ROOT}/test_xlsx_export"
fi


if [[ "$POS" == "off" ]] ; then
    echo ================ remove POS ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/point_of_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_adyen"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_cache"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_daily_sales_reports"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_discount"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_epson_printer"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_epson_printer_restaurant"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_hr"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_hr_restaurant"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_loyalty"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_mercury"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_mrp"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_restaurant"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_restaurant_adyen"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_restaurant_stripe"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_sale_loyalty"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_sale_margin"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_sale_product_configurator"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_six"
    MODULES+=" ${ODOO_ADDONS_ROOT}/pos_stripe"

    MODULES+=" ${ODOO_ADDONS_ROOT}/loyalty"
    MODULES+=" ${ODOO_ADDONS_ROOT}/loyalty_delivery"

fi

if [[ "$PAYMENT" == "off" ]] ; then
    echo ================ remove PAYMENT ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment"
    #/data/odoo/odoo-plate/${ODOO_ADDONS_ROOT}/payment/data/payment_provider_data.xml
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_adyen"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_alipay"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_aps"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_asiapay"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_authorize"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_buckaroo"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_custom"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_demo"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_flutterwave"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_mercado_pago"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_mollie"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_ogone"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_paypal"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_payulatam"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_payumoney"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_razorpay"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_sips"
    MODULES+=" ${ODOO_ADDONS_ROOT}/payment_stripe"
fi

if [[ "$ACCOUNT" == "off" ]] ; then
     echo ================ remove ACCOUNT ========================
    # account depens on product
    MODULES+=" ${ODOO_ADDONS_ROOT}/account"

    MODULES+=" ${ODOO_ADDONS_ROOT}/account_check_printing"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_debit_note"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_edi"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_edi_proxy_client"

    MODULES+=" ${ODOO_ADDONS_ROOT}/account_edi_ubl_cii"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_fleet"

    MODULES+=" ${ODOO_ADDONS_ROOT}/account_lock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_payment"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_payment_invoice_online_payment_patch"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_qr_code_sepa"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_sequence"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_tax_python"
    MODULES+=" ${ODOO_ADDONS_ROOT}/account_test"

    #MODULES+=" ${ODOO_ADDONS_ROOT}/digest" account depends on digest
  
fi

#analytic
#association

#attachment_indexation

#auth_ldap
#auth_oauth
#auth_password_policy
#auth_password_policy_portal
#auth_password_policy_signup
#auth_signup
#auth_totp
#auth_totp_mail
#auth_totp_mail_enforce
#auth_totp_portal

#barcodes
#barcodes_gs1_nomenclature

#base
#base_address_extended
#base_automation
#base_geolocalize
#base_iban
#base_import
#base_import_module
#base_install_request
#base_setup
#base_sparse_field
#base_vat

#board
#bus
#calendar

if [[ "$SMS" == "off" ]] ; then
    echo ================ remove SMS ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/calendar_sms"
    MODULES+=" ${ODOO_ADDONS_ROOT}/project_sms"
    MODULES+=" ${ODOO_ADDONS_ROOT}/sms"
    MODULES+=" ${ODOO_ADDONS_ROOT}/stock_sms"
fi

#contacts

if [[ "$CRM" == "off" ]] ; then
    echo ================ remove CRM ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/crm"
    MODULES+=" ${ODOO_ADDONS_ROOT}/crm_iap_enrich"
    MODULES+=" ${ODOO_ADDONS_ROOT}/crm_iap_mine"
    MODULES+=" ${ODOO_ADDONS_ROOT}/crm_livechat"
    MODULES+=" ${ODOO_ADDONS_ROOT}/crm_mail_plugin"
    MODULES+=" ${ODOO_ADDONS_ROOT}/crm_sms"
fi
#data_recycle

if [[ "$DELIVERY" == "off" ]] ; then
    echo ================ remove DELIVERY ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/delivery"
    MODULES+=" ${ODOO_ADDONS_ROOT}/delivery_mondialrelay"
    MODULES+=" ${ODOO_ADDONS_ROOT}/delivery_stock_picking_batch"
fi

if [[ "$IM_LIVECHAT" == "off" ]] ; then
  #im_livechat depends
  echo ================ remove IM_LIVECHAT ========================
  MODULES+=" ${ODOO_ADDONS_ROOT}/im_livechat"
  MODULES+=" ${ODOO_ADDONS_ROOT}/im_livechat_mail_bot"
fi


if [[ "$EVENT" == "off" ]] ; then
    echo ================ remove EVENT ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/event"
    MODULES+=" ${ODOO_ADDONS_ROOT}/event_booth"
    MODULES+=" ${ODOO_ADDONS_ROOT}/event_booth_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/event_crm"
    MODULES+=" ${ODOO_ADDONS_ROOT}/event_crm_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/event_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/event_sms"
fi

if [[ "$FLEET" == "off" ]] ; then
    echo ================ remove FLEET ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/fleet"
fi

if [[ "$GAMIFICATION" == "off" ]] ; then
    echo ================ remove GAMIFICATION ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/gamification"
    MODULES+=" ${ODOO_ADDONS_ROOT}/gamification_sale_crm"
fi

if [[ "$GOOGLE" == "off" ]] ; then
  echo ================ remove GOOGLE ========================
  MODULES+=" ${ODOO_ADDONS_ROOT}/google_account"
  MODULES+=" ${ODOO_ADDONS_ROOT}/google_calendar"
  MODULES+=" ${ODOO_ADDONS_ROOT}/google_gmail"
fi

#google_recaptcha
#hr
#hr_attendance
#hr_contract

if [[ "$HR" == "off" ]] ; then
  echo ================ remove HR ========================
  MODULES+=" ${ODOO_ADDONS_ROOT}/hr_expense"
  MODULES+=" ${ODOO_ADDONS_ROOT}/hr_fleet"
  MODULES+=" ${ODOO_ADDONS_ROOT}/hr_gamification"
  MODULES+=" ${ODOO_ADDONS_ROOT}/hr_recruitment_survey"
  MODULES+=" ${ODOO_ADDONS_ROOT}/hr_skills_survey"
fi

if [[ "$MAINTENANCE" == "off" ]] ; then
  echo ================ remove MAINTENANCE ========================
  MODULES+=" ${ODOO_ADDONS_ROOT}/maintenance"
fi

#hr_holidays
#hr_holidays_attendance
#hr_hourly_cost
#hr_maintenance
#hr_org_chart
#hr_presence

#hr_recruitment
#hr_recruitment_skills


#hr_skills
#hr_skills_slides



#hr_timesheet
#hr_timesheet_attendance

#hr_work_entry
#hr_work_entry_contract
#hr_work_entry_holidays
#http_routing

if [[ "$HW" == "off" ]] ; then
  echo ============== remove HW ============================
  MODULES+=" ${ODOO_ADDONS_ROOT}/hw_drivers"
  MODULES+=" ${ODOO_ADDONS_ROOT}/hw_escpos"
  MODULES+=" ${ODOO_ADDONS_ROOT}/hw_posbox_homepage"
fi

if [[ "$IAP" == "off" ]] ; then
    echo ============== remove IAP ============================
    
    #ovaj modul je neophodan?!
    #MODULES+=" ${ODOO_ADDONS_ROOT}/iap"
    
    MODULES+=" ${ODOO_ADDONS_ROOT}/iap_crm"
    MODULES+=" ${ODOO_ADDONS_ROOT}/iap_mail"
fi

#link_tracker

if [[ "$LUNCH" == "off" ]] ; then
    echo ============== remove LUNCH ============================
    MODULES+=" ${ODOO_ADDONS_ROOT}/lunch"
fi

#mail
#mail_bot
#mail_bot_hr

#mail_group
#mail_plugin


if [[ "$MASS_MAILING" == "off" ]] ; then
    echo ============== remove MASS_MAILING ============================
    #mass_mailing

    MODULES+=" ${ODOO_ADDONS_ROOT}/mass_mailing_crm"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mass_mailing_crm_sms"

    MODULES+=" ${ODOO_ADDONS_ROOT}/mass_mailing_event"
    MODULES+=" ${ODOO_ADDONS_ROOT}/mass_mailing_event_track"

    MODULES+=" ${ODOO_ADDONS_ROOT}/mass_mailing_event_sms"

    MODULES+=" ${ODOO_ADDONS_ROOT}/mass_mailing_event_track_sms"
    #mass_mailing_sale
    MODULES+=" ${ODOO_ADDONS_ROOT}/mass_mailing_sale_sms"
    #mass_mailing_slides
    MODULES+=" ${ODOO_ADDONS_ROOT}/mass_mailing_sms"
    #mass_mailing_themes
fi

#membership
#note
#onboarding

#partner_autocomplete

#MODULES+=" ${ODOO_ADDONS_ROOT}/phone_validation"


if [[ "$PORTAL" == "off" ]] ; then
    echo ================ remove PORTAL ========================
    #im_live_chat => digest => portal
    MODULES+=" ${ODOO_ADDONS_ROOT}/portal"
    MODULES+=" ${ODOO_ADDONS_ROOT}/portal_rating"
fi

#privacy_lookup

if [[ "$STOCK" == "off" ]] ; then
  echo ================ remove STOCK ========================
  MODULES+=" ${ODOO_ADDONS_ROOT}/stock"
  MODULES+=" ${ODOO_ADDONS_ROOT}/stock_account"
  MODULES+=" ${ODOO_ADDONS_ROOT}/stock_dropshipping"
  MODULES+=" ${ODOO_ADDONS_ROOT}/stock_landed_costs"
  MODULES+=" ${ODOO_ADDONS_ROOT}/stock_picking_batch"
fi

if [[ "$PRODUCT" == "off" ]] ; then
    echo ================ remove PRODUCT ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/product"
    MODULES+=" ${ODOO_ADDONS_ROOT}/product_email_template"
    MODULES+=" ${ODOO_ADDONS_ROOT}/product_expiry"
    MODULES+=" ${ODOO_ADDONS_ROOT}/product_images"
    MODULES+=" ${ODOO_ADDONS_ROOT}/product_margin"
    MODULES+=" ${ODOO_ADDONS_ROOT}/product_matrix"
fi

#project
#project_hr_expense
#project_mail_plugin
#project_mrp
#project_purchase
#project_sale_expense

#project_timesheet_holidays


if [[ "$PURCHASE" == "off" ]] ; then
    echo ================ remove PURCHASE ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/purchase"
    MODULES+=" ${ODOO_ADDONS_ROOT}/purchase_mrp"
    MODULES+=" ${ODOO_ADDONS_ROOT}/purchase_price_diff"
    MODULES+=" ${ODOO_ADDONS_ROOT}/purchase_product_matrix"
    MODULES+=" ${ODOO_ADDONS_ROOT}/purchase_requisition"
    MODULES+=" ${ODOO_ADDONS_ROOT}/purchase_requisition_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/purchase_stock"
fi


#rating
if [[ "$REPAIR" == "off" ]] ; then
    echo ================ remove REPAIR ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/repair"
fi

#resource
#sale_timesheet_margin


#snailmail
#MODULES+=" ${ODOO_ADDONS_ROOT}/snailmail_account"

if [[ "$SOCIAL_MEDIA" == "off" ]] ; then
    echo ================ remove SOCIAL_MEDIA ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/social_media"
fi

if [[ "$SURVEY" == "off" ]] ; then
    echo ================ remove SURVEY ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/survey"
fi


if [[ "$SPREADSHEET" == "off" ]] ; then
    echo ================ remove SPREADSHEET ========================
    #spreadsheet
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_account"

    #spreadsheet_dashboard

    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_account"
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_event_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_hr_expense"
    #spreadsheet_dashboard_hr_timesheet
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_im_livechat"
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_pos_hr"
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_purchase"
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_purchase_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_sale_expense"
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_sale_timesheet"
    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_stock_account"

    MODULES+=" ${ODOO_ADDONS_ROOT}/spreadsheet_dashboard_website_sale_slides"
fi


if [[ "$THEME" == "off" ]] ; then
    echo ================ remove THEME ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_anelusia"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_artists"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_avantgarde"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_aviato"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_beauty"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_bewise"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_bistro"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_bookstore"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_buzzy"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_clean"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_cobalt"
    #MODULES+=" ${ODOO_ADDONS_ROOT}/theme_common"
    #MODULES+=" ${ODOO_ADDONS_ROOT}/theme_default
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_enark"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_graphene"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_kea"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_kiddo"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_loftspace"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_monglia"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_nano"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_notes"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_odoo_experts"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_orchid"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_paptic"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_real_estate"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_test_custo"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_treehouse"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_vehicle"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_yes"
    MODULES+=" ${ODOO_ADDONS_ROOT}/theme_zap"
fi

#transifex
#uom
#utm
#web
#web_editor
#web_kanban_gauge

if [[ "$WEBSITE" == "off" ]] ; then
    echo ================ remove WEBSITE ========================
    MODULES+=" ${ODOO_ADDONS_ROOT}/website"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_blog"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_crm"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_crm_iap_reveal"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_crm_livechat"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_crm_partner_assign"

    MODULES+=" ${ODOO_ADDONS_ROOT}/website_crm_sms"

    MODULES+=" ${ODOO_ADDONS_ROOT}/website_customer"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_booth"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_booth_exhibitor"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_booth_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_booth_sale_exhibitor"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_crm"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_crm_questions"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_exhibitor"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_jitsi"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_meet"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_meet_quiz"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_questions"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_track"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_track_live"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_track_live_quiz"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_event_track_quiz"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_form_project"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_forum"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_google_map"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_hr_recruitment"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_jitsi"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_links"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_livechat"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_mail"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_mail_group"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_mass_mailing"

    MODULES+=" ${ODOO_ADDONS_ROOT}/website_mass_mailing_sms"

    MODULES+=" ${ODOO_ADDONS_ROOT}/website_membership"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_partner"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_payment"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_payment_authorize"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_payment_paypal"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_profile"

    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_autocomplete"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_comparison"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_comparison_wishlist"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_delivery"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_delivery_mondialrelay"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_digital"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_loyalty"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_loyalty_delivery"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_picking"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_product_configurator"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_slides"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_stock"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_stock_product_configurator"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_stock_wishlist"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sale_wishlist"

    MODULES+=" ${ODOO_ADDONS_ROOT}/website_slides"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_slides_forum"

    MODULES+=" ${ODOO_ADDONS_ROOT}/website_slides_survey"
    MODULES+=" ${ODOO_ADDONS_ROOT}/website_sms"

    MODULES+=" ${ODOO_ADDONS_ROOT}/website_twitter"
fi

#web_tour
#web_unsplash


for mod in $MODULES ; do scripts/remove.sh $mod ; done
