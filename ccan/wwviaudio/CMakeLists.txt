set( CCAN_LIB_DEPENDS
    ccan_ogg_to_pcm
    # TODO: libvorbis vorbisfile portaudio
)

set( CCAN_H_DEPENDS
    ccan_likely
)

ccan_helper_create_module("ccan_wwviaudio" 1 0 0)
