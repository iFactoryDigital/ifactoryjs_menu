<block-menu>
  <block on-refresh={ opts.onRefresh } on-save={ opts.onSave } on-remove={ opts.onRemove } on-menu={ onMenu } on-menu-class={ onMenuClass } block={ opts.block } data={ opts.data } ref="block" class="block-menu">
    <yield to="body">
      <div if={ !opts.block.menu } class="py-5 text-center">Select Menu</div>
      <menu name={ opts.block.menu } classes={ opts.block.menuClass } />
    </yield>

    <yield to="modal">
      <div class="form-group">
        <label>
          Menu Name
        </label>
        <input class="form-control" ref="menu" value={ opts.block.menu } onchange={ opts.onMenu } />
      </div>
    </yield>
  </block>

  <script>

    /**
     * on class

     * @param  {Event} e
     */
    async onMenu (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.block.menu = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data);
    }
  
    /**
     * on class

     * @param  {Event} e
     */
    async onMenuClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.block.menuClass = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data);
    }

  </script>
</block-menu>
