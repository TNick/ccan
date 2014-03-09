set( CCAN_MOD_DEPENDENCIES
    ccan_ogg_to_pcm
    # TODO: libvorbis vorbisfile portaudio
    ccan_likely
)

ccan_helper_create_module("ccan_wwviaudio" 1 0 0)
