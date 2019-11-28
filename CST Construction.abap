    DATA: tl_nota TYPE STANDARD TABLE OF zst_nota,
          wl_nota TYPE zst_nota.

    FIELD-SYMBOLS: <xmlh> TYPE j1b_nf_xml_header.

    IF in_xml_item-l1_20_cst IS NOT INITIAL.
      wl_nota-cst    = in_xml_item-l1_20_cst.
      wl_nota-predbc = in_xml_item-l1_20_predbc.
      wl_nota-vbc    = in_xml_item-l1_20_vbc.
      wl_nota-picms  = in_xml_item-l1_20_picms.
      wl_nota-vicms  = in_xml_item-l1_20_vicms.
*     pFCP
*     vBCFCP
*     vFCP
    ELSEIF in_xml_item-l1_40_cst IS NOT INITIAL.

      wl_nota-cst = in_xml_item-l1_40_cst.

    ELSEIF in_xml_item-l1_51_cst IS NOT INITIAL.
      wl_nota-cst   = in_xml_item-l1_51_cst.
      wl_nota-vbc   = in_xml_item-l1_51_vbc.
      wl_nota-picms = in_xml_item-l1_51_picms.
      wl_nota-vicms = in_xml_item-l1_51_vicms.
*      pFCP
*      vBCFCP
*      vFCP
    ELSEIF in_xml_item-l1_70_cst IS NOT INITIAL.
      wl_nota-cst    = in_xml_item-l1_70_cst.
      wl_nota-predbc = in_xml_item-l1_70_predbc.
      wl_nota-vbc    = in_xml_item-l1_70_vbc.
      wl_nota-picms  = in_xml_item-l1_70_picms.
      wl_nota-vicms  = in_xml_item-l1_70_vicms.
*     pFCP
*     vBCFCP
*     vFCP
    ELSEIF in_xml_item-l1_90_cst IS NOT INITIAL.

      wl_nota-cst = in_xml_item-l1_90_cst.

    ENDIF.

    "Tabela da fill_header.
    ASSIGN ('(SAPLJ_1B_NFE)XMLH') TO <xmlh>.

    wl_nota-bukrs = in_doc-bukrs.
    wl_nota-branch = in_doc-branch.
    wl_nota-werks =  in_lin-werks.
    wl_nota-parvw = in_doc-parvw.
    wl_nota-parid = in_doc-parid.
    wl_nota-docnum = in_xml_item-docnum.
    wl_nota-itmnum = in_xml_item-itmnum.
    wl_nota-cprod  = in_xml_item-cprod.
    wl_nota-crt    = <xmlh>-crt.
    wl_nota-finnfe = <xmlh>-finnfe.
    wl_nota-tpnf   = <xmlh>-tpnf.
    wl_nota-emituf = <xmlh>-cuf.
    wl_nota-destuf = <xmlh>-c1_uf.
    wl_nota-cfop   = in_xml_item-cfop.
    wl_nota-vicmsdeson = out_item-vicmsdeson.
    wl_nota-motdesicms = out_item-motdeson.
    wl_nota-cbenef    = out_item-cbenef.
    wl_nota-vprod     = in_xml_item-vprod.
    wl_nota-vicmsop   = out_item-vicmsop.
    wl_nota-pdif      = out_item-picmsdif.
    wl_nota-vicmsdif  = out_item-vicmsdif.