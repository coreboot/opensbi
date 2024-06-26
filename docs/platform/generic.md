Generic Platform
================

The **Generic** platform is a flattened device tree (FDT) based platform
where all platform specific functionality is provided based on FDT passed
by previous booting stage. The **Generic** platform allows us to use same
OpenSBI firmware binaries on various emulators, simulators, FPGAs, and
boards.

By default, the generic FDT platform makes following assumptions:

1. platform features are default
2. platform stack size is default
3. platform has no quirks or work-arounds

The above assumptions (except 1) can be overridden by adding special platform
callbacks which will be called based on FDT root node compatible string.

Users of the generic FDT platform will have to ensure that:

1. Various FDT based drivers under lib/utils directory are upto date
   based on their platform requirements
2. The FDT passed by previous booting stage has DT compatible strings and
   DT properties in sync with the FDT based drivers under lib/utils directory
3. The FDT must have "stdout-path" DT property in the "/chosen" DT node when
   a platform has multiple serial ports or consoles
4. On multi-HART platform, the FDT must have a DT node for IPI device and
   lib/utils/ipi directory must have corresponding FDT based IPI driver
5. The FDT must have a DT node for timer device and lib/utils/timer directory
   must have corresponding FDT based timer driver

To build the platform-specific library and firmware images, provide the
*PLATFORM=generic* parameter to the top level `make` command.

Platform Options
----------------

The *Generic* platform does not have any platform-specific options.

RISC-V Platforms Using Generic Platform
---------------------------------------

* **Andes AE350 Platform** (*[andes-ae350.md]*)
* **QEMU RISC-V Virt Machine** (*[qemu_virt.md]*)
* **Renesas RZ/Five SoC** (*[renesas-rzfive.md]*)
* **Shakti C-class SoC Platform** (*[shakti_cclass.md]*)
* **SiFive HiFive Unleashed** (*[sifive_fu540.md]*)
* **Spike** (*[spike.md]*)
* **T-HEAD C9xx series Processors** (*[thead-c9xx.md]*)

[andes-ae350.md]: andes-ae350.md
[qemu_virt.md]: qemu_virt.md
[renesas-rzfive.md]: renesas-rzfive.md
[shakti_cclass.md]: shakti_cclass.md
[sifive_fu540.md]: sifive_fu540.md
[spike.md]: spike.md
[thead-c9xx.md]: thead-c9xx.md
