/* Demo Note:  This demo uses a FileProgress class that handles the UI for displaying the file name and percent complete.
The FileProgress class is not part of SWFUpload.
*/


/* **********************
   Event Handlers
   These are my custom event handlers to make my
   web application behave the way I went when SWFUpload
   completes different tasks.  These aren't part of the SWFUpload
   package.  They are part of my application.  Without these none
   of the actions SWFUpload makes will show up in my application.
   ********************** */
function fileQueued(file) {
	try {
    // var progress = new FileProgress(file, this.customSettings.progressTarget);
    // progress.show()
    // progress.setStatus("Pending...");
    // progress.toggleCancel(true, this);

	} catch (ex) {
		this.debug(ex);
	}

}

function fileQueueError(file, errorCode, message) {
	try {
		if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
			alert("You have attempted to queue too many files.\n" + (message === 0 ? "You have reached the upload limit." : "You may select " + (message > 1 ? "up to " + message + " files." : "one file.")));
			return;
		}

		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setError();
		progress.toggleCancel(false);

		switch (errorCode) {
		case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
			progress.setStatus("File is too big.");
			this.debug("Error Code: File too big, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
			progress.setStatus("Cannot upload Zero Byte files.");
			this.debug("Error Code: Zero byte file, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
			progress.setStatus("Invalid File Type.");
			this.debug("Error Code: Invalid File Type, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		default:
			if (file !== null) {
				progress.setStatus("Unhandled Error");
			}
			this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		}
	} catch (ex) {
        this.debug(ex);
    }
}

function fileDialogComplete(numFilesSelected, numFilesQueued) {
	try {
    // if (numFilesSelected > 0) {
    //  document.getElementById(this.customSettings.cancelButtonId).disabled = false;
    // }
		
		/* I want auto start the upload and I can do that here */
		this.startUpload();
	} catch (ex)  {
    this.debug(ex);
	}
}

function uploadStart(file) {
	try {
		/* I don't want to do any file validation or anything,  I'll just update the UI and
		return true to indicate that the upload should start.
		It's important to update the UI here because in Linux no uploadProgress events are called. The best
		we can do is say we are uploading.
		 */
    // var progress = new FileProgress(file, this.customSettings.progressTarget);
    // progress.show()
    // progress.setStatus("Uploading...");
    // progress.toggleCancel(true, this);
    $("#fsUploadProgress").show()
	}
	catch (ex) {}
	
	return true;
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
	try {
    // var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);

    // var progress = new FileProgress(file, this.customSettings.progressTarget);
    // progress.setProgress(percent);
    // progress.setStatus("Uploading...");
	} catch (ex) {
		this.debug(ex);
	}
}

function uploadSuccess(file, serverData) {
	try {
	  $("#fsUploadProgress").hide()
		var rr = JSON.parse(serverData);
		$('#logo_img').empty()
		$('#logo_img').append($("<img />").attr('src', rr.customer_logo));
		$('#logo_img').append($("<input type='hidden' name='contact[tmp_upload]' />").attr('value', rr.tmp_id));
	} catch (ex) {
		this.debug(ex);
	}
}

function uploadError(file, errorCode, message) {
	try {
	  $("#fsUploadProgress").hide()

		switch (errorCode) {
		case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
			$.ctNotify("Upload Error: " + message, 'error');
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
  		$.ctNotify("Upload Failed.", 'error');
			break;
		case SWFUpload.UPLOAD_ERROR.IO_ERROR:
   		$.ctNotify("Server (IO) Error", 'error');
			break;
		case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
  		$.ctNotify("Security Error", 'error');
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
  		$.ctNotify("Upload limit exceeded", 'error');
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
  		$.ctNotify("Failed Validation.  Upload skipped.", 'error');
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
			// If there aren't any files left (they were all cancelled) disable the cancel button
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
			$.ctNotify("Stopped", 'error');
  		
			break;
		default:
  		$.ctNotify("Unhandled Error: " + errorCode, 'error');
			break;
		}
	} catch (ex) {
        this.debug(ex);
    }
}

function uploadComplete(file) {
}

// This event comes from the Queue Plugin
function queueComplete(numFilesUploaded) {
  // var status = document.getElementById("divStatus");
  // status.innerHTML = numFilesUploaded + " file" + (numFilesUploaded === 1 ? "" : "s") + " uploaded.";
}