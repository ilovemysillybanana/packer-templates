# packer-templates

This is a fork of [mwrock/packer-templates]( https://github.com/mwrock/packer-templates ) that I maintain for my own personal use. I only maintain the hyper-v and virtualbox images as those are the ones I use. There are a few changes to get it to work, I'm not sure if his repo works/ed for him but it had many problems and I had to address those.

## Vendoring the cookbooks
The Windows 2016 templates use the `packer-templates` Chef cookbook to provision the image. The cookbook located in `cookbooks/packer-templates` has dependencies on a few community cookbooks. These cookbooks need to be downloaded. To do this:

1. `cd` to `cookbooks/packer-templates`
2. Run `berks vendor ../../vendor/cookbooks`

This downloads all dependencies and saves them in vendor/cookbooks. From here packer will upload them to the image being built.

## Invoking the template
Invoke `packer` to run a template like this:
```
packer build -force -only virtualbox-iso .\vbox-2016.json
```
