//= require jquery
//= require jquery_ujs

var imageCurrentIndex = -1
var selectedThemeId = -1
var imageLength = -1
var currentIndex = 1
var userId = $("#user-id").attr('value')


set_display_image(false)

$('#quantity-input').on('change', function() {
    if ($(this).val() > 10){
        $(this).val(10)
    }
    else if ($(this).val() < 1){
        $(this).val(1)
    }
});



function applyTheme(theme) {
    console.log("Applying theme:", theme);
    selectedThemeId = theme
    $.ajax({
        type: "get",
        url: "/api/get_theme",
        data: {theme_id: theme},
        dataType: 'json'
    }).done(function (data_return) {
        imageLength = data_return.image_length
        currentIndex = 1
        setupImage(data_return.image_data.id, data_return.image_data.name, data_return.image_data.file)
    })
        .fail(function (data_return) {
            console.log("error: data_return = " + data_return);
        });
    set_display_image(true)
}

function next(){
    if (currentIndex >= imageLength)
        return

    $.ajax({
        type: "get",
        url: "/api/get_next_image",
        data: {theme_id: selectedThemeId, image_id: imageCurrentIndex},
        dataType: 'json'
    }).done(function (data_return) {
        currentIndex++
        setupImage(data_return.image_data.id, data_return.image_data.name, data_return.image_data.file)
    })
        .fail(function (data_return) {
            console.log("error: data_return = " + data_return);
        });

}

function prev(){
    if (currentIndex <= 1)
        return
    $.ajax({
        type: "get",
        url: "/api/get_prev_image",
        data: {theme_id: selectedThemeId, image_id: imageCurrentIndex},
        dataType: 'json'
    }).done(function (data_return) {
        currentIndex--
        setupImage(data_return.image_data.id, data_return.image_data.name, data_return.image_data.file)
    })
        .fail(function (data_return) {
            console.log("error: data_return = " + data_return);
        });
}

function setupImage(new_image_current_index, new_image_name, new_image_file){
    imageCurrentIndex = new_image_current_index;
    let imageName = new_image_name;
    let oneImageFile = new_image_file;
    $('#image-name-text').text(imageName);
    let pathImage = "../../assets/" + oneImageFile;
    $(".img-center").attr({title: "Selected image" });
    $(".img-center img").attr({alt: "Selected Image", src: pathImage, title: "Selected image" });

    $("#image-page-text").text(`${currentIndex}/${imageLength}`)
    if (currentIndex >= imageLength)
        $(".img-next").hide()
    else
        $(".img-next").show()
    if (currentIndex <= 1)
        $(".img-prev").hide()
    else
        $(".img-prev").show()

    $.ajax({
        type: "get",
        url: "/api/get_value_for_image",
        data: {image_id: imageCurrentIndex},
        dataType: 'json'
    }).done(function (data_return) {
        if (data_return.value)
            $('.image-user-value>input').val(data_return.value.value)
        else
            $('.image-user-value>input').val(1)
    })
        .fail(function (data_return) {
            console.log("error: data_return = " + data_return);
        });
}

function set_display_image(display){
    if (!display){
        $('.img-center').css({"display": "none"});
        $('.image-name').css({"display": "none"});
        $('.image-switch').css({"display": "none"});
        $('.image-user-value').css({"display": "none"});
    }else{
        $('.img-center').show();
        $('.image-name').show();
        $('.image-switch').show();
        $('.image-user-value').show();
    }
}

function save_quantity(){
    let val = $('#quantity-input').val()
    $.ajax({
        type: "post",
        url: "/api/set_value",
        data: {image_id: imageCurrentIndex, value: val, user_id: userId},
        dataType: 'json'
    })
}