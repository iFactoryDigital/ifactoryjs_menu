<menu>
  <menu-children children={ getMenu(opts.name) } name={ opts.name } classes={ opts.classes } />

  <script>
    // Add mixins
    this.mixin('menu');

    /**
     * Gets menu
     *
     * @param  {String} name
     *
     * @return {Array}
     */
    getMenu (name) {
      // Get menu
      let menu = (this.menu[name] || []).filter((m) => !m.parent);

      // Return menu
      return menu;
    }
  </script>
</menu>
