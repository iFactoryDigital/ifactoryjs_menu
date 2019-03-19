
// Require dependencies
const Controller = require('controller');

// Require helpers
const menuHelper  = helper('menu');
const blockHelper = helper('cms/block');

// Require cache
const menuConfig = cache('menus');

/**
 * Build menu controller
 *
 * @priority 5
 */
class MenuController extends Controller {
  /**
   * Construct home controller
   */
  constructor() {
    // Run super
    super();

    // Bind methods
    this.build = this.build.bind(this);

    // Bind private methods
    this._menus = this._menus.bind(this);

    // Build eden
    this.build();
  }

  /**
   * Build app
   *
   * @param {express} app
   */
  build() {
    // On render
    this.eden.pre('view.compile', (render) => {
      // get menus
      const menus = render.state.menus;

      // Delete from state
      delete render.state.menus;

      // Return
      if (render.isJSON || !menus) return;

      // Move menus
      render.menus = menus;

      // Loop menu
      (Object.keys(render.menus) || []).forEach((key) => {
        // Get classes
        render.menus[key].sort((a, b) => {
          // Return sort
          return b.priority === a.priority ? 0 : (b.priority < a.priority ? -1 : 1);
        });
      });
    });

    // Set app
    this.eden.router.use(async (req, res, next) => {
      // Set req remove
      req.menu = {};

      // Set menus
      res.locals.menus = await this._menus(req.user, menuConfig);

      // Add function
      req.menu.create = (type, route, item) => {
        // Add menu item
        menuHelper.create(type, route, item, res);

        // Return
        return req.menu;
      };

      // Edit function
      req.menu.update = (type, route, item) => {
        // Edit menu item
        menuHelper.update(type, route, item, res);

        // Return
        return req.menu;
      };

      // Remove function
      req.menu.remove = (type, route) => {
        // Remove menu item
        menuHelper.remove(type, route, res);

        // Return
        return req.menu;
      };

      // Run next
      next();
    });

    // register simple block
    blockHelper.block('menu.element', {
      acl         : false,
      for         : ['frontend'],
      title       : 'Menu Block',
      description : 'Menu block',
    }, async (req, block) => {
      // return
      return {
        tag : 'menu',
      };
    }, async (req, block) => { });
  }


  /**
   * Returns menus
   *
   * @param {user} User
   * @param {Array} menus
   *
   * @return {Array}
   */
  async _menus(User, menus) {
    // Clone menus
    const Menus = JSON.parse(JSON.stringify(menus));

    // Add hook
    await this.eden.hook('menus.init', Menus);

    // Loop menu types
    for (const type in Menus) {
      // Check property
      if (!Menus.hasOwnProperty(type)) continue;

      // Set routes
      const Routes = [];

      // Set menu
      Menus[type] = Menus[type] || [];

      // Loop actual menus
      for (let i = (Menus[type].length - 1); i >= 0; i--) {
        // Check routes
        if (Routes.includes(Menus[type][i].route)) {
          // Delete from menu
          Menus[type].splice(i, 1);

          // Continue
          continue;
        }

        // Push to routes
        Routes.push(Menus[type][i].route);
      }

      // Check menu type
      if (!Menus[type].length) {
        // Remove menu
        delete Menus[type];

        // Continue
        continue;
      }
    }

    // Return menus
    return Menus;
  }
}

/**
 * Export menu controller
 *
 * @type {menu}
 */
exports = module.exports = MenuController;
