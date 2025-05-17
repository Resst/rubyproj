
console.log()

$.ajax({
    type: "get",
    url: "api/next_image",
    data: { index: imageCurrentIndex,
        theme_id: selectedThemeId,
        length: themeImagesSize },
    dataType: 'json'
}).done(function (data_return) {
    console.log("success:  " + data_return.notice );
    imageCurrentIndex = data_return.new_image_index;
    oneImageName = data_return.name;
    oneImageFile = data_return.file;
    oneImageId = data_return.image_id;
    $('.image_display h2.up').append().html(oneImageName);
    var pathImage = "assets/pictures/" + oneImageFile;
    $(".img-center").attr({title: "Selected image" });
    $(".img-center img").attr({alt: "Selected Image", src:
        pathImage, title: "Selected image" });
})
    .fail(function (data_return) {
        console.log("error: data_return = " + data_return);
    });
