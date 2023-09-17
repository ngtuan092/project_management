$(document).ready(() => {
  $("#select_date").on("change", (e) => {
    const value = $("#select_date").val();
    const currentUrl = window.location.href;
    const separator = currentUrl.includes("?") ? "&" : "?";

    const newUrl = `${currentUrl}${separator}date=${value}`;
    window.location.href = newUrl;
  });
});
