var pelleditorsaver = (function () {

	// details of this plug-in
	var featureDetails = {
		name: "Pell Editor Saver",
		scriptVersion: "1.0",
		url: "https://github.com/commi235/apex-conn-js-advanced",
		license: "MIT License"
	};

	return {
		initialize: function (pThis, pOpts) {

			// print some initial info if debug mode is enabled
			apex.debug.info({
				"fct": featureDetails.name + " - initialize",
				"arguments": {
					"pThis": pThis,
					"pOpts": pOpts
				},
				"featureDetails": featureDetails
			});

			// check  all affected elements from plug-in settings
			$.each(pThis.affectedElements, function (i, obj) {
				var id = $(obj).attr("id");

				if (id.length) {
					// try to get editor content and throw error a region or object is selected that is not an pell editor plug-in region
					try {
						var content = apex.region(id).getContent();
					} catch (e) {
						apex.debug.error({
							"fct": featureDetails.name + " - " + "get editor content",
							"msg": "Error while try to getContent of Pell Editor. Maybe your affected element is not a Pell Editor Plug-in Region.",
							"err": e,
							"featureDetails": featureDetails
						});
						apex.da.resume(pThis.resumeCallback, true);
						return;
					}

					// split content into array of str for uploading to the server
					// APEX does also support CLOB Upload but this is not official so this method is used
					var chunkArr = apex.server.chunk(content);

					// send data to server and give call callback if everything worked
					apex.server.plugin(pOpts.ajaxID, {
						x01: pOpts.functionType,
						f01: chunkArr,
						pageItems: pOpts.items2Submit
					}, {
						dataType: "text",
						loadingIndicator: "#" + id,
						loadingIndicatorPosition: "centered",
						success: function (pData) {
							apex.debug.info({
								"fct": featureDetails.name + " - " + "upload clob",
								"msg": "Clob Upload successful",
								"featureDetails": featureDetails
							});
							apex.da.resume(pThis.resumeCallback, false);
						},
						error: function (jqXHR, textStatus, errorThrown) {
							apex.debug.error({
								"fct": featureDetails.name + " - " + "upload clob",
								"msg": "Clob Upload error",
								"jqXHR": jqXHR,
								"textStatus": textStatus,
								"errorThrown": errorThrown,
								"featureDetails": featureDetails
							});
							apex.da.handleAjaxErrors(jqXHR, textStatus, errorThrown, pThis.resumeCallback);
						}
					});
				} else {
					apex.debug.info({
						"fct": featureDetails.name,
						"msg": "The affected element has no element id and is not an APEX Pell Editor Plug-in Region",
						"featureDetails": featureDetails
					});
					apex.da.resume(pThis.resumeCallback, true);
				}
			});
		}
	}
})();