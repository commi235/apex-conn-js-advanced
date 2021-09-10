prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_210100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.0-13'
,p_default_workspace_id=>50660625675380979112
,p_default_application_id=>130859
,p_default_id_offset=>50676798607940323305
,p_default_owner=>'WKSP_APEXCONNWORKSHOP'
);
end;
/
 
prompt APPLICATION 130859 - Advanced JavaScript in APEX
--
-- Application Export:
--   Application:     130859
--   Name:            Advanced JavaScript in APEX
--   Date and Time:   19:51 Monday April 26, 2021
--   Exported By:     RONNY.WEISS@KONTRON-AIS.COM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 568458294285588621
--   Manifest End
--   Version:         21.1.0-13
--   Instance ID:     63113759365424
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/rwmk_pelleditorsaver
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(568458294285588621)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'RWMK.PELLEDITORSAVER'
,p_display_name=>'Pell Editor Saver'
,p_category=>'COMPONENT'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_image_prefix=>'&G_APEX_NITRO_PLUGIN_FILES.'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION F_AJAX (',
'    P_DYNAMIC_ACTION   IN APEX_PLUGIN.T_DYNAMIC_ACTION,',
'    P_PLUGIN           IN APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT IS',
'    VR_RESULT       APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT;',
'    VR_PLSQL_BLOCK  P_DYNAMIC_ACTION.ATTRIBUTE_01%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_01;',
'    VR_PARAMETERS   APEX_EXEC.T_PARAMETERS;',
'    VR_CLOB         CLOB := EMPTY_CLOB();',
'    VR_TMP_STR      VARCHAR2(32767);',
'BEGIN',
'    DBMS_LOB.CREATETEMPORARY(',
'        LOB_LOC   => VR_CLOB,',
'        CACHE     => FALSE,',
'        DUR       => DBMS_LOB.SESSION',
'    );',
'',
'    -- Join the VARCHAR2 array back to clob content of the editor',
'    FOR I IN 1..APEX_APPLICATION.G_F01.COUNT LOOP',
'        VR_TMP_STR := WWV_FLOW.G_F01(I);',
'        IF DBMS_LOB.GETLENGTH(VR_TMP_STR) > 0 THEN',
'            DBMS_LOB.WRITEAPPEND(',
'                VR_CLOB,',
'                DBMS_LOB.GETLENGTH(VR_TMP_STR),',
'                VR_TMP_STR',
'            );',
'        END IF;',
'',
'    END LOOP;',
'',
'    APEX_EXEC.ADD_PARAMETER(',
'        P_PARAMETERS   => VR_PARAMETERS,',
'        P_NAME         => ''EDITOR_CLOB'',',
'        P_VALUE        => VR_CLOB',
'    );',
'    -- Execute given PL/SQL Block to store the clob.',
'    APEX_EXEC.EXECUTE_PLSQL(',
'        P_PLSQL_CODE        => VR_PLSQL_BLOCK,',
'        P_AUTO_BIND_ITEMS   => TRUE,',
'        P_SQL_PARAMETERS    => VR_PARAMETERS',
'    );',
'    ',
'    DBMS_LOB.FREETEMPORARY(VR_CLOB);',
'    RETURN VR_RESULT;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        DBMS_LOB.FREETEMPORARY(VR_CLOB);',
'        APEX_DEBUG.ERROR(''Pell Editor Saver - Error while upload clob'');',
'        APEX_DEBUG.ERROR(SQLERRM);',
'        APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'        RAISE;',
'END;',
'',
'FUNCTION F_RENDER (',
'    P_DYNAMIC_ACTION   IN APEX_PLUGIN.T_DYNAMIC_ACTION,',
'    P_PLUGIN           IN APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT IS',
'',
'    VR_RESULT             APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;',
'    VR_ITEMS_2_SUBMIT     P_DYNAMIC_ACTION.ATTRIBUTE_02%TYPE := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(P_DYNAMIC_ACTION.ATTRIBUTE_02);',
'BEGIN',
'    -- Load JS file',
'    APEX_JAVASCRIPT.ADD_LIBRARY(',
'        P_NAME                  => ''pelleditorsaver'',',
'        P_DIRECTORY             => P_PLUGIN.FILE_PREFIX,',
'        P_CHECK_TO_ADD_MINIFIED => TRUE,',
'        P_KEY                   => ''rwmkpelleditorsaverjssrc''',
'    );',
'',
'    -- Call initial JS function',
'    VR_RESULT.JAVASCRIPT_FUNCTION   := ''function () { var self = this; pelleditorsaver.initialize( self, { '' ||',
'        APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''ajaxID'', APEX_PLUGIN.GET_AJAX_IDENTIFIER) ||',
'        APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''items2Submit'', VR_ITEMS_2_SUBMIT ) || ',
'    ''}); }'';',
'',
'    RETURN VR_RESULT;',
'END F_RENDER;'))
,p_api_version=>2
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX'
,p_standard_attributes=>'REGION:JQUERY_SELECTOR:REQUIRED:STOP_EXECUTION_ON_ERROR:WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'This plug-in is sued to save the data of the "Pell Editor Region" plug-in. It transfers the clob region content to the server so that you can store your input in the database.'
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/commi235/apex-conn-js-advanced'
,p_files_version=>6
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(579595237752522621)
,p_plugin_id=>wwv_flow_api.id(568458294285588621)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'PL/SQL to Store Editor Content'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    VR_CLOB       CLOB := :EDITOR_CLOB;',
'    VR_COL_NAME   VARCHAR2(100) := NVL(:P1_COLLECTION_NAME, ''MY_COLLECTION'');',
'BEGIN',
'    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(P_COLLECTION_NAME => VR_COL_NAME);',
'    APEX_COLLECTION.ADD_MEMBER(',
'        P_COLLECTION_NAME   => VR_COL_NAME,',
'        P_CLOB001           => VR_CLOB',
'    );',
'END;'))
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'DECLARE',
'    VR_CLOB       CLOB := :EDITOR_CLOB;',
'    VR_COL_NAME   VARCHAR2(100) := NVL(:P1_COLLECTION_NAME, ''MY_COLLECTION'');',
'BEGIN',
'    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(P_COLLECTION_NAME => VR_COL_NAME);',
'    APEX_COLLECTION.ADD_MEMBER(',
'        P_COLLECTION_NAME   => VR_COL_NAME,',
'        P_CLOB001           => VR_CLOB',
'    );',
'END;',
'</pre>'))
,p_help_text=>'This PL/SQL block is used to store the pell editor content into the database.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(579930117205525829)
,p_plugin_id=>wwv_flow_api.id(568458294285588621)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Used to submit items when executing PL/SQL block above.'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7661722070656C6C656469746F727361766572203D202866756E6374696F6E202829207B0A0A092F2F2064657461696C73206F66207468697320706C75672D696E0A09766172206665617475726544657461696C73203D207B0A09096E616D653A202250';
wwv_flow_api.g_varchar2_table(2) := '656C6C20456469746F72205361766572222C0A090973637269707456657273696F6E3A2022312E30222C0A090975726C3A202268747470733A2F2F6769746875622E636F6D2F636F6D6D693233352F617065782D636F6E6E2D6A732D616476616E636564';
wwv_flow_api.g_varchar2_table(3) := '222C0A09096C6963656E73653A20224D4954204C6963656E7365220A097D3B0A0A0972657475726E207B0A0909696E697469616C697A653A2066756E6374696F6E202870546869732C20704F70747329207B0A0A0909092F2F207072696E7420736F6D65';
wwv_flow_api.g_varchar2_table(4) := '20696E697469616C20696E666F206966206465627567206D6F646520697320656E61626C65640A090909617065782E64656275672E696E666F287B0A0909090922666374223A206665617475726544657461696C732E6E616D65202B2022202D20696E69';
wwv_flow_api.g_varchar2_table(5) := '7469616C697A65222C0A0909090922617267756D656E7473223A207B0A0909090909227054686973223A2070546869732C0A090909090922704F707473223A20704F7074730A090909097D2C0A09090909226665617475726544657461696C73223A2066';
wwv_flow_api.g_varchar2_table(6) := '65617475726544657461696C730A0909097D293B0A0A0909092F2F20636865636B2020616C6C20616666656374656420656C656D656E74732066726F6D20706C75672D696E2073657474696E67730A090909242E656163682870546869732E6166666563';
wwv_flow_api.g_varchar2_table(7) := '746564456C656D656E74732C2066756E6374696F6E2028692C206F626A29207B0A09090909766172206964203D2024286F626A292E617474722822696422293B0A0A090909096966202869642E6C656E67746829207B0A09090909092F2F207472792074';
wwv_flow_api.g_varchar2_table(8) := '6F2067657420656469746F7220636F6E74656E7420616E64207468726F77206572726F72206120726567696F6E206F72206F626A6563742069732073656C65637465642074686174206973206E6F7420616E2070656C6C20656469746F7220706C75672D';
wwv_flow_api.g_varchar2_table(9) := '696E20726567696F6E0A0909090909747279207B0A09090909090976617220636F6E74656E74203D20617065782E726567696F6E286964292E676574436F6E74656E7428293B0A09090909097D20636174636820286529207B0A09090909090961706578';
wwv_flow_api.g_varchar2_table(10) := '2E64656275672E6572726F72287B0A0909090909090922666374223A206665617475726544657461696C732E6E616D65202B2022202D2022202B202267657420656469746F7220636F6E74656E74222C0A09090909090909226D7367223A20224572726F';
wwv_flow_api.g_varchar2_table(11) := '72207768696C652074727920746F20676574436F6E74656E74206F662050656C6C20456469746F722E204D6179626520796F757220616666656374656420656C656D656E74206973206E6F7420612050656C6C20456469746F7220506C75672D696E2052';
wwv_flow_api.g_varchar2_table(12) := '6567696F6E2E222C0A0909090909090922657272223A20652C0A09090909090909226665617475726544657461696C73223A206665617475726544657461696C730A0909090909097D293B0A090909090909617065782E64612E726573756D6528705468';
wwv_flow_api.g_varchar2_table(13) := '69732E726573756D6543616C6C6261636B2C2074727565293B0A09090909090972657475726E3B0A09090909097D0A0A09090909092F2F2073706C697420636F6E74656E7420696E746F206172726179206F662073747220666F722075706C6F6164696E';
wwv_flow_api.g_varchar2_table(14) := '6720746F20746865207365727665720A09090909092F2F204150455820646F657320616C736F20737570706F727420434C4F422055706C6F6164206275742074686973206973206E6F74206F6666696369616C20736F2074686973206D6574686F642069';
wwv_flow_api.g_varchar2_table(15) := '7320757365640A0909090909766172206368756E6B417272203D20617065782E7365727665722E6368756E6B28636F6E74656E74293B0A0A09090909092F2F2073656E64206461746120746F2073657276657220616E6420676976652063616C6C206361';
wwv_flow_api.g_varchar2_table(16) := '6C6C6261636B2069662065766572797468696E6720776F726B65640A0909090909617065782E7365727665722E706C7567696E28704F7074732E616A617849442C207B0A0909090909097830313A20704F7074732E66756E6374696F6E547970652C0A09';
wwv_flow_api.g_varchar2_table(17) := '09090909096630313A206368756E6B4172722C0A090909090909706167654974656D733A20704F7074732E6974656D73325375626D69740A09090909097D2C207B0A09090909090964617461547970653A202274657874222C0A0909090909096C6F6164';
wwv_flow_api.g_varchar2_table(18) := '696E67496E64696361746F723A20222322202B2069642C0A0909090909096C6F6164696E67496E64696361746F72506F736974696F6E3A202263656E7465726564222C0A090909090909737563636573733A2066756E6374696F6E202870446174612920';
wwv_flow_api.g_varchar2_table(19) := '7B0A09090909090909617065782E64656275672E696E666F287B0A090909090909090922666374223A206665617475726544657461696C732E6E616D65202B2022202D2022202B202275706C6F616420636C6F62222C0A0909090909090909226D736722';
wwv_flow_api.g_varchar2_table(20) := '3A2022436C6F622055706C6F6164207375636365737366756C222C0A0909090909090909226665617475726544657461696C73223A206665617475726544657461696C730A090909090909097D293B0A09090909090909617065782E64612E726573756D';
wwv_flow_api.g_varchar2_table(21) := '652870546869732E726573756D6543616C6C6261636B2C2066616C7365293B0A0909090909097D2C0A0909090909096572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A0909';
wwv_flow_api.g_varchar2_table(22) := '0909090909617065782E64656275672E6572726F72287B0A090909090909090922666374223A206665617475726544657461696C732E6E616D65202B2022202D2022202B202275706C6F616420636C6F62222C0A0909090909090909226D7367223A2022';
wwv_flow_api.g_varchar2_table(23) := '436C6F622055706C6F6164206572726F72222C0A0909090909090909226A71584852223A206A715848522C0A09090909090909092274657874537461747573223A20746578745374617475732C0A0909090909090909226572726F725468726F776E223A';
wwv_flow_api.g_varchar2_table(24) := '206572726F725468726F776E2C0A0909090909090909226665617475726544657461696C73223A206665617475726544657461696C730A090909090909097D293B0A09090909090909617065782E64612E68616E646C65416A61784572726F7273286A71';
wwv_flow_api.g_varchar2_table(25) := '5848522C20746578745374617475732C206572726F725468726F776E2C2070546869732E726573756D6543616C6C6261636B293B0A0909090909097D0A09090909097D293B0A090909097D20656C7365207B0A0909090909617065782E64656275672E69';
wwv_flow_api.g_varchar2_table(26) := '6E666F287B0A09090909090922666374223A206665617475726544657461696C732E6E616D652C0A090909090909226D7367223A202254686520616666656374656420656C656D656E7420686173206E6F20656C656D656E7420696420616E6420697320';
wwv_flow_api.g_varchar2_table(27) := '6E6F7420616E20415045582050656C6C20456469746F7220506C75672D696E20526567696F6E222C0A090909090909226665617475726544657461696C73223A206665617475726544657461696C730A09090909097D293B0A0909090909617065782E64';
wwv_flow_api.g_varchar2_table(28) := '612E726573756D652870546869732E726573756D6543616C6C6261636B2C2074727565293B0A090909097D0A0909097D293B0A09097D0A097D0A7D2928293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(570984711425299488)
,p_plugin_id=>wwv_flow_api.id(568458294285588621)
,p_file_name=>'pelleditorsaver.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7661722070656C6C656469746F7273617665723D66756E6374696F6E28297B76617220653D7B6E616D653A2250656C6C20456469746F72205361766572222C73637269707456657273696F6E3A22312E30222C75726C3A2268747470733A2F2F67697468';
wwv_flow_api.g_varchar2_table(2) := '75622E636F6D2F636F6D6D693233352F617065782D636F6E6E2D6A732D616476616E636564222C6C6963656E73653A224D4954204C6963656E7365227D3B72657475726E7B696E697469616C697A653A66756E6374696F6E28612C74297B617065782E64';
wwv_flow_api.g_varchar2_table(3) := '656275672E696E666F287B6663743A652E6E616D652B22202D20696E697469616C697A65222C617267756D656E74733A7B70546869733A612C704F7074733A747D2C6665617475726544657461696C733A657D292C242E6561636828612E616666656374';
wwv_flow_api.g_varchar2_table(4) := '6564456C656D656E74732C66756E6374696F6E28722C6E297B76617220693D24286E292E617474722822696422293B696628692E6C656E677468297B7472797B766172206F3D617065782E726567696F6E2869292E676574436F6E74656E7428297D6361';
wwv_flow_api.g_varchar2_table(5) := '7463682874297B72657475726E20617065782E64656275672E6572726F72287B6663743A652E6E616D652B22202D2067657420656469746F7220636F6E74656E74222C6D73673A224572726F72207768696C652074727920746F20676574436F6E74656E';
wwv_flow_api.g_varchar2_table(6) := '74206F662050656C6C20456469746F722E204D6179626520796F757220616666656374656420656C656D656E74206973206E6F7420612050656C6C20456469746F7220506C75672D696E20526567696F6E2E222C6572723A742C66656174757265446574';
wwv_flow_api.g_varchar2_table(7) := '61696C733A657D292C766F696420617065782E64612E726573756D6528612E726573756D6543616C6C6261636B2C2130297D766172206C3D617065782E7365727665722E6368756E6B286F293B617065782E7365727665722E706C7567696E28742E616A';
wwv_flow_api.g_varchar2_table(8) := '617849442C7B7830313A742E66756E6374696F6E547970652C6630313A6C2C706167654974656D733A742E6974656D73325375626D69747D2C7B64617461547970653A2274657874222C6C6F6164696E67496E64696361746F723A2223222B692C6C6F61';
wwv_flow_api.g_varchar2_table(9) := '64696E67496E64696361746F72506F736974696F6E3A2263656E7465726564222C737563636573733A66756E6374696F6E2874297B617065782E64656275672E696E666F287B6663743A652E6E616D652B22202D2075706C6F616420636C6F62222C6D73';
wwv_flow_api.g_varchar2_table(10) := '673A22436C6F622055706C6F6164207375636365737366756C222C6665617475726544657461696C733A657D292C617065782E64612E726573756D6528612E726573756D6543616C6C6261636B2C2131297D2C6572726F723A66756E6374696F6E28742C';
wwv_flow_api.g_varchar2_table(11) := '722C6E297B617065782E64656275672E6572726F72287B6663743A652E6E616D652B22202D2075706C6F616420636C6F62222C6D73673A22436C6F622055706C6F6164206572726F72222C6A715848523A742C746578745374617475733A722C6572726F';
wwv_flow_api.g_varchar2_table(12) := '725468726F776E3A6E2C6665617475726544657461696C733A657D292C617065782E64612E68616E646C65416A61784572726F727328742C722C6E2C612E726573756D6543616C6C6261636B297D7D297D656C736520617065782E64656275672E696E66';
wwv_flow_api.g_varchar2_table(13) := '6F287B6663743A652E6E616D652C6D73673A2254686520616666656374656420656C656D656E7420686173206E6F20656C656D656E7420696420616E64206973206E6F7420616E20415045582050656C6C20456469746F7220506C75672D696E20526567';
wwv_flow_api.g_varchar2_table(14) := '696F6E222C6665617475726544657461696C733A657D292C617065782E64612E726573756D6528612E726573756D6543616C6C6261636B2C2130297D297D7D7D28293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(587313936145092564)
,p_plugin_id=>wwv_flow_api.id(568458294285588621)
,p_file_name=>'pelleditorsaver.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
