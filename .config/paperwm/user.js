// -*- mode: gnome-shell -*-
const Extension = imports.misc.extensionUtils.getCurrentExtension();
const Tiling = Extension.imports.tiling;
const Keybindings = Extension.imports.keybindings;

function enable() {
    // Runs when extension is enabled
}

function disable() {
    // Runs when extension is disabled
}

/*
 * PaperWM user configuration
 */
function init() {
    /*
     * Add a rule to make Ulauncher always float on the scratch layer.
     */
    Tiling.defwinprop({
        wm_class: "Ulauncher",
        scratch_layer: true,
    });

    /*
     * You can add other rules here.
     *
     * Tiling.defwinprop({
     * wm_class: "Gnome-calculator",
     * scratch_layer: true,
     * });
     */
}
