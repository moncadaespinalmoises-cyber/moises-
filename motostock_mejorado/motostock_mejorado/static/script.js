document.addEventListener("DOMContentLoaded", function () {
    console.log("MotoStock funcionando correctamente");

    const searchInput = document.querySelector(".search-input");
    const tableRows = document.querySelectorAll(".inventory-table tbody tr");

    if (searchInput && tableRows.length > 0) {
        searchInput.addEventListener("keyup", function () {
            const texto = searchInput.value.toLowerCase();

            tableRows.forEach(function (fila) {
                const contenido = fila.textContent.toLowerCase();

                if (contenido.includes(texto)) {
                    fila.style.display = "";
                } else {
                    fila.style.display = "none";
                }
            });
        });
    }
});