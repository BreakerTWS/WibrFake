// app/javascript/packs/hola_mundo.js
document.addEventListener("DOMContentLoaded", function() {
    const iniciarSesionDiv = document.getElementById("iniciar-sesion");
    iniciarSesionDiv.addEventListener("click", function() {
      alert("Usuario o contrasena incorrectos");
    });
  });