# CyVault brand asset

`cyvault_mark.svg` is an original, dependency-free source asset created for this
repository. It combines a restrained blue/teal shield with a keyhole on a navy
field. Platform PNGs are reproducibly rendered with `librsvg`:

```bash
rsvg-convert --width 192 --height 192 \
  --output android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png \
  assets/brand/cyvault_mark.svg
```

Other density/Apple sizes use the pixel size declared by their resource name.
No prior-project image, Lottie file, font or brand asset is reused.
