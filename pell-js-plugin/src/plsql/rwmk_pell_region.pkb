create or replace package body rwmk_pell_region
as

  function render
  (
    p_region              in apex_plugin.t_region
  , p_plugin              in apex_plugin.t_plugin
  , p_is_printer_friendly in boolean
  )
    return apex_plugin.t_region_render_result
  as
    l_js_code varchar2(32676);
    l_return apex_plugin.t_region_render_result;
  begin

    apex_plugin_util.debug_region
    (
      p_plugin => p_plugin
    , p_region => p_region
    );

    sys.htp.p( '<div id="' || p_region.static_id || '_editor"></div>' );

    l_js_code := 'apex.jQuery("#' || p_region.static_id || '").pelleditorregion({' ||
      apex_javascript.add_attribute
      (
        p_name      => 'ajaxIdentifier'
      , p_value     => apex_plugin.get_ajax_identifier
      , p_add_comma => true
      ) ||
      apex_javascript.add_attribute
      (
        p_name      => 'itemsToSubmit'
      , p_value     => apex_plugin_util.page_item_names_to_jquery( p_page_item_names => p_region.ajax_items_to_submit )
      , p_add_comma => false
      ) ||
    '});';

    apex_javascript.add_onload_code( p_code => l_js_code );

    return l_return;

  end render;

  procedure load_data
  (
    p_region in apex_plugin.t_region
  , p_plugin in apex_plugin.t_plugin
  )
  as
    l_context apex_exec.t_context;
    l_col_idx pls_integer;
  begin

    l_context := apex_exec.open_query_context( p_first_row => 1, p_max_rows  => 1 );

    l_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_01
      , p_is_required => true
      , p_data_type   => apex_exec.c_data_type_clob
      );
    
    apex_json.open_object;

    if apex_exec.next_row( p_context => l_context ) then
      apex_json.write( p_name => 'hasData', p_value => true );

      apex_json.write
      ( 
        p_name  => 'content'
      , p_value => apex_exec.get_clob( p_context => l_context, p_column_idx => l_col_idx )
      );
    else
      apex_json.write( p_name => 'hasData', p_value => false );
    end if;

    apex_json.write( p_name => 'success', p_value => true );
    apex_json.close_all;
  end load_data;

  function ajax
  (
    p_region in apex_plugin.t_region
  , p_plugin in apex_plugin.t_plugin
  )
    return apex_plugin.t_region_ajax_result
  as
    l_action varchar2(32767);
    l_return apex_plugin.t_region_ajax_result;
  begin

    l_action := apex_application.g_x01;

    case upper(l_action)
      when 'LOAD' then
        load_data
        (
          p_region => p_region
        , p_plugin => p_plugin
        );
      else
        apex_json.open_object;
        apex_json.write( p_name => 'success', p_value => false );
        apex_json.write( p_name => 'errorMessage', p_value => 'Unsupported operation.' );
        apex_json.close_all;
    end case;

    return l_return;

  end ajax;


end rwmk_pell_region;
/
