/*global apex pell*/

/*
  Use a so-called IFFE here to not pollute the namespace.
  It also isolates variables where needed.
  Then we are making it very clear which dependencies we have by using parameters
  for used modules and mapping then in the execution part of the IFFE.
*/
(function (pell, $, region, debug, server, da, event) {
  const EDITOR_SUFFIX = "_editor";
  const WIDGET_NAMESPACE = "rwmk";
  const WIDGET_NAME = "pelleditorregion";
  const WIDGET_TYPE = WIDGET_NAMESPACE + "." + WIDGET_NAME;

  /*
    This is utilizing the jQuery Widget Factory.
    As most APEX also uses jQuery Widgets for native page items and regions,
    it makes sense to utilize the same pattern.
  */
  $.widget(WIDGET_TYPE, {
    options: {
      ajaxIdentifier: null,
      itemsToSubmit: null,
    },
    _create: function () {
      debug.trace("Start widget create.", { regionId: this.regionId });
      // We can use [0] here as the Widget Factory always hand in exactly one element
      this.regionId = this.element[0].id;
      this.editorId = this.regionId + EDITOR_SUFFIX;
      this.editorSelector = "#" + this.editorId;

      this.editor$ = pell.init({
        element: document.getElementById(this.editorId),
        onChange: (html) => {
          event.trigger(this.editorSelector, "change", {
            regionId: this.regionId,
            html: html,
          });
        },
      });

      region.create(this.regionId, {
        widget: () => {
          return this.element;
        },
        refresh: () => {
          this._refresh();
        },
        getEditorInstance: () => {
          return this.editor$;
        },
        save: () => {
          this._save();
        },
        getContent: () => {
          return this.editor$.content.innerHTML;
        },
        widgetName: WIDGET_NAME,
        type: WIDGET_TYPE,
      });
      debug.trace("End widget create.", { regionId: this.regionId });
    },
    _refresh: function () {
      debug.trace("Entering refresh.", this.regionId);
      // Call Plugin callback here
      server
        .plugin(
          this.options.ajaxIdentifier,
          {
            pageItems: $(this.options.itemsToSubmit, apex.gPageContext$),
            x01: "LOAD",
          },
          {
            refreshObject: "#" + this.editorId,
            loadingIndicator: "#" + this.editorId,
          }
        )
        .then((pData) => {
          if (pData.success) {
            this.editor$.content.innerHTML = pData.hasData ? pData.content : "";
          }
        })
        .fail((jqXHR, textStatus, errorThrown) => {
          da.handleAjaxError(jqXHR, textStatus, errorThrown);
        });
    },
    _save: function () {
      apex.mesaage.alert("Save called.");
    },
  });
})(
  pell,
  apex.jQuery,
  apex.region,
  apex.debug,
  apex.server,
  apex.da,
  apex.event
);
