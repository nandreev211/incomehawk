var swfu;

window.onload = function() {
	var settings = {
		flash_url : "/swfupload.swf",
		upload_url: '/upload',
		file_size_limit : "5 MB",
		file_types : "*.*",
		file_types_description : "All Files",
		file_upload_limit : 50,
		file_queue_limit : 0,
		custom_settings : {
      progressTarget : "fsUploadProgress",
      cancelButtonId : "btnCancel"
		},
		debug: false,

		// Button settings
		button_image_url: "/images/TestImageNoText.png",
		button_width: "71",
		button_height: "26",
		button_placeholder_id: "browse-logo-name",
		
		// The event handler functions are defined in handlers.js
		file_queued_handler : fileQueued,
		file_queue_error_handler : fileQueueError,
		file_dialog_complete_handler : fileDialogComplete,
		upload_start_handler : uploadStart,
		upload_progress_handler : uploadProgress,
		upload_error_handler : uploadError,
		upload_success_handler : uploadSuccess,
		upload_complete_handler : uploadComplete,
		queue_complete_handler : queueComplete	// Queue plugin event
	};

  swfu = new SWFUpload(settings);
};
