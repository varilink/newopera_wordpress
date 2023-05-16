;; -----------------------------------------------------------------------------
;; gimp/newopera.scm
;; -----------------------------------------------------------------------------


;; Source:
;; https://creazilla.com/nodes/16599-musical-notes-colorful-clipart
(define musicalNotesImage (car (gimp-file-load RUN-NONINTERACTIVE
    "src/musical-notes-colorful-clipart-xl.png"
    "src/musical-notes-colorful-clipart-xl.png"
)))

;; Text created to overlay the musicalNotesImage. Text is Sans-serif, 100px
;; with a kerning of 15.0 and font colour #154360.
(define curvedTextImage (car (gimp-file-load RUN-NONINTERACTIVE
    "src/curved-logo-text.png"
    "src/curved-logo-text.png"
)))

;; Orpheus image from the New Opera Company archive
(define orpheusImage (car (gimp-file-load RUN-NONINTERACTIVE
    "src/OrpheusItUKHsm.jpg"
    ""
)))

;; Create outpus

;; logo image used in the website header and footer

(let*

    (
        (notesImage (car (gimp-image-duplicate musicalNotesImage)))
        (textImage (car (gimp-image-duplicate curvedTextImage)))
        (textLayer (car (gimp-layer-new-from-drawable
            (car (gimp-image-get-active-layer textImage))
            notesImage
        )))
    )

    (gimp-image-insert-layer notesImage
        textLayer ; layer
        0         ; parent (main layer stack)
        -1        ; position (top of layer stack)
    )
    (gimp-image-crop notesImage
        1920 740 0 215 ; width, height, offset x, offset y
    )

    (let*

        (
            (headerImage (car (gimp-image-duplicate notesImage)))
            (headerDrawable (car (gimp-image-merge-visible-layers
                  headerImage CLIP-TO-IMAGE
            )))
        )

        (gimp-image-scale headerImage 480 185)
        (file-webp-save
            RUN-NONINTERACTIVE      ; Interactive, non-interactive
            headerImage             ; Input image
            headerDrawable          ; Drawable to save
            "dest/header-logo.webp" ; The name of the file to save the image to
            "dest/header-logo.webp" ; The name entered
            0                       ; preset
            0                       ; Use lossless encoding
            90                      ; Quality of the image
            100                     ; Quality of the image's alpha channel
            0                       ; Use layers for animation
            0                       ; Loop animation infinitely
            0                       ; Minimize animation size
            0                       ; Maximum distance between key-frames
            0                       ; Toggle saving exif data
            0                       ; Toggle saving iptc data
            0                       ; Toggle saving xmp data
            0                       ; Delay
            0                       ; Force delay on all frames
        )

        (gimp-image-delete headerImage)

    )

    (let*

        (
            (footerImage (car (gimp-image-duplicate notesImage)))
            (footerDrawable (car (gimp-image-merge-visible-layers
                  footerImage CLIP-TO-IMAGE
            )))
        )

        (gimp-image-convert-grayscale footerImage)
        (gimp-drawable-invert footerDrawable TRUE)
        (gimp-image-scale footerImage 480 185)
        (file-webp-save
            RUN-NONINTERACTIVE      ; Interactive, non-interactive
            footerImage             ; Input image
            footerDrawable          ; Drawable to save
            "dest/footer-logo.webp" ; The name of the file to save the image to
            "dest/footer-logo.webp" ; The name entered
            0                       ; preset
            0                       ; Use lossless encoding
            90                      ; Quality of the image
            100                     ; Quality of the image's alpha channel
            0                       ; Use layers for animation
            0                       ; Loop animation infinitely
            0                       ; Minimize animation size
            0                       ; Maximum distance between key-frames
            0                       ; Toggle saving exif data
            0                       ; Toggle saving iptc data
            0                       ; Toggle saving xmp data
            0                       ; Delay
            0                       ; Force delay on all frames
        )

        (gimp-image-delete footerImage)

    )

    (gimp-image-delete notesImage)
    (gimp-image-delete textImage)

)

;; Banner image

(let*

    (
        (bannerImage (car (gimp-image-duplicate orpheusImage)))
        (bannerDrawable (car (gimp-image-get-active-layer bannerImage)))
    )

    (file-webp-save
        RUN-NONINTERACTIVE ; Interactive, non-interactive
        bannerImage        ; Input image
        bannerDrawable     ; Drawable to save
        "dest/banner.webp" ; The name of the file to save the image to
        "dest/banner.webp" ; The name entered
        0                  ; preset
        0                  ; Use lossless encoding
        90                 ; Quality of the image
        100                ; Quality of the image's alpha channel
        0                  ; Use layers for animation
        0                  ; Loop animation infinitely
        0                  ; Minimize animation size
        0                  ; Maximum distance between key-frames
        0                  ; Toggle saving exif data
        0                  ; Toggle saving iptc data
        0                  ; Toggle saving xmp data
        0                  ; Delay
        0                  ; Force delay on all frames
    )

    (gimp-image-delete bannerImage)

)

(gimp-image-delete musicalNotesImage)
(gimp-image-delete curvedTextImage)
(gimp-image-delete orpheusImage)
(gimp-quit 0)
