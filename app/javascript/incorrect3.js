// app/javascript/packs/page_basic.js
document.addEventListener("DOMContentLoaded", function() {
  const formulario = document.getElementById("formulario");
  const iniciarSesionDiv = document.getElementById("iniciar-sesion");

  iniciarSesionDiv.addEventListener("click", function(event) {
      event.preventDefault();

      const formData = new FormData(formulario);

      fetch(formulario.action, {
          method: 'POST',
          body: formData,
          headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
      })
      .then(response => {
          if (response.ok) {
              alert("Usuario o contraseña incorrectos");
          } else {
            alert("Usuario o contraseña incorrectos");
          }
      })
      .catch(error => {
          console.error('Error:', error);
      });
  });
});