<menu-children>
  <ul class="{ opts.classes && opts.classes.main ? opts.classes.main : 'nav' } level-{ this.level }" if={ this.children }>
    <li each={ item, i in this.children } class={ renderMainClass(item) } if={ typeof item.acl !== 'undefined' ? this.acl.validate(item.acl) : true }>
      <a class={ renderLinkClass(item) } href={ item.route }>
        <i if={ item.icon } class="{ item.icon }" />
        { this.t(item.title) }
      </a>
      <menu-children if={ getChildren(item).length } children={ getChildren(item) } name={ opts.name } classes={ opts.classes } level={ this.level + 1 } />
    </li>
  </ul>

  <script>
    // Add mixins
    this.mixin('acl');
    this.mixin('menu');
    this.mixin('i18n');
    this.mixin('mount');
    
    // set children
    this.level    = (opts.level || 0);
    this.children = opts.children;

    /**
     * Check if item has children
     *
     * @param {object} item
     */
    getChildren (item) {
      // return found
      return this.menu[opts.name].filter((m) => m.parent === item.route);
    }

    /**
     * Renders main class
     *
     * @param  {object} item
     *
     * @return {string}
     */
    renderMainClass (item) {
      // Set class
      const rtnClass = [];

      // Check for opts class
      rtnClass.push(opts.classes && opts.classes.item ? opts.classes.item : 'nav-item');
      rtnClass.push(this.getChildren(item).length ? 'has-children' : '');
      if (this.isActive(item)) rtnClass.push('active');

      // Join class
      return rtnClass.join(' ').split('  ').join(' ');
    }

    /**
     * Renders link class
     *
     * @param  {object} item
     *
     * @return {string}
     */
    renderLinkClass (item) {
      // Set class
      const rtnClass = [];

      // Check for opts class
      rtnClass.push(opts.classes && opts.classes.link ? opts.classes.link : 'nav-link');
      if (this.isActive(item)) rtnClass.push('active');

      // Return joined class
      return rtnClass.join(' ');
    }

    /**
     * Renders dropdown class
     *
     * @param  {object} item
     *
     * @return {string}
     */
    renderDropdownClass (item) {
      // Set class
      const rtnClass = [];

      // Check for opts class
      rtnClass.push(opts.classes && opts.classes.dropdown ? opts.classes.dropdown : 'dropdown-menu');

      // Return joined class
      return rtnClass.join(' ');
    }

    /**
     * Renders dropdown link class
     *
     * @param  {object} item
     *
     * @return {string}
     */
    renderDropdownLink (item) {
      // Set class
      const rtnClass = [];

      // Check for opts class
      rtnClass.push(opts.classes && opts.classes.sub ? opts.classes.sub : 'dropdown-menu');

      // Return joined class
      return rtnClass.join(' ');
    }
    
    /**
     * returns is active
     *
     * @param  {Object}  item
     *
     * @return {Boolean}
     */
    isActive (item) {
      // find active children
      if ((this.getChildren(item) || []).find((i) => {
        // return child active
        return this.mnt.path.indexOf(i.route) === 0 && (i.route === this.mnt.path || i.route !== opts.base) && (i.route !== '/' || this.mnt.path === '/');
      })) return true;

      // return is active
      return this.mnt.path.indexOf(item.route) === 0 && (item.route === this.mnt.path || item.route !== opts.base) && (item.route !== '/' || this.mnt.path === '/');
    }
    
    /**
     * on update
     *
     * @type {*}
     */
    this.on('update', () => {
      // set children
      this.level    = (opts.level || 0);
      this.children = opts.children;
      
    });
    
  </script>
</menu-children>
