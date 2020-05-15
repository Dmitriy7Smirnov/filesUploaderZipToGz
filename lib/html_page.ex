defmodule HtmlPage do
    def get_page_with_form do
      "<!DOCTYPE html>
      <html>
          <head>
              <script>
                  function deleteName(fx) {
                      let files = fx[0].files;
                      if (files.length > 0) {

                          let minPathArrLength = Number.MAX_VALUE;
                          for (let file of files) {
                              let currPathArrLength = file.webkitRelativePath.split('/').length
                              if (minPathArrLength > currPathArrLength) {
                                  minPathArrLength = currPathArrLength;
                              }
                          }

                          let maxDepthOfCorrection = minPathArrLength - 2;

                          let formData = new FormData();
                          for (let i = 0; i < fx[0].files.length; i++) {
                              let path = fx[0].files[i].webkitRelativePath;
                              let pathArr = path.split('/');
                              pathArr.splice(0, maxDepthOfCorrection);
                              formData.append(fx[0].files[i].name, new Blob([fx[0].files[i]]), pathArr.join('/'));
                          }

                          /*let response = fetch('/fileHandler', {
                              method: 'POST',
                              body: formData
                          });*/


                          const xhr = new XMLHttpRequest();

// listen for `load` event
xhr.onload = () => {
    console.log(`The transfer is completed: ${xhr.status} ${xhr.response}`);
    document.getElementById('console').innerHTML += `The transfer is completed:<br>status: ${xhr.status}<br>response: ${xhr.response}<br>`;
};

// listen for `error` event
xhr.onerror = () => {
    console.error('Download failed.');
}

// listen for `abort` event
xhr.onabort = () => {
    console.error('Download cancelled.');
    document.getElementById('console').innerHTML += 'Download cancelled.<br>';
}

// listen for `progress` event
xhr.onprogress = (event) => {
    // event.loaded returns how many bytes are downloaded
    // event.total returns the total number of bytes
    // event.total is only available if server sends `Content-Length` header
    console.log(`Downloaded ${event.loaded} of ${event.total} bytes`);
    document.getElementById('console').innerHTML += 'upload complete<br>';
}

xhr.upload.onprogress = (event) => {
    // event.loaded returns how many bytes are downloaded
    // event.total returns the total number of bytes
    // event.total is only available if server sends `Content-Length` header
    document.getElementById(`myBar`).innerHTML = `Uploaded ${Math.ceil(event.loaded * 100/event.total)} %`;
    console.log(`upload on progress ${event.loaded} of ${event.total} bytes`);
}


                          xhr.withCredentials = true;
                          xhr.open('POST', '/fileHandler');
                          xhr.send(formData);

                      }
                  };
              </script>
          </head>
          <body>
              <form id='formElem' action='fileHandler' method='post' enctype='multipart/form-data' onsubmit='deleteName(this); return false;'>
                  <input type='file' id='ctrl' webkitdirectory>
                  <input type='submit'>
              </form>

              <div id='myProgress'>
                  <div id='myBar'></div>
              </div>
              <div id = 'console'></div>
          </body>
      </html>"
  end
end
