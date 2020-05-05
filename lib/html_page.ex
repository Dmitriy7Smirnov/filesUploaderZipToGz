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

                          let response = fetch('/fileHandler', {
                              method: 'POST',
                              body: formData
                          });
                      }
                  };
              </script>
          </head>
          <body>
              <form id='formElem' action='fileHandler' method='post' enctype='multipart/form-data' onsubmit='deleteName(this); return false;'>
                  <input type='file' id='ctrl' webkitdirectory>
                  <input type='submit'>
              </form>
          </body>
      </html>"
  end
end
