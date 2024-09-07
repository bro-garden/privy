// app/javascript/plain-scripts/simplemde_initializer.js
document.addEventListener("turbo:load", () => {
  console.log('Hello from immprada simple');
  const editorElement = document.getElementById("markdown-editor");

  if (editorElement) {
    const editor = new SimpleMDE({
      element: editorElement,
      spellChecker: false,
      status: false,
      toolbar: ["bold", "italic", "heading", "|", "quote", "link", "unordered-list", "ordered-list"],
    });

    const hiddenField = document.getElementById("message-content");
    editor.codemirror.on("change", () => {
      hiddenField.value = editor.value();
    });
  }
});
