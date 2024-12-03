local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local rubato = require("lib.rubato") -- Charger Rubato
local awful = require("awful")
local cairo = require("lgi").cairo

-- Obtenez la hauteur et la largeur de l'écran
local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local border_size = 10 -- Taille des bords en pixels
local wibar_height = 30 -- Hauteur de la wibar (ajustez si nécessaire)

-- Fonction pour appliquer un effet de flou
local function apply_blur(cr, width, height)
    local blur_radius = 10
    local surface = cairo.ImageSurface.create(cairo.Format.ARGB32, width, height)
    local context = cairo.Context(surface)

    context:set_source_surface(cr:get_target(), 0, 0)
    context:paint()

    for i = 1, blur_radius do
        context:set_source_surface(surface, 0, 0)
        context:mask_surface(surface, 0, 0)
    end

    cr:set_source_surface(surface, 0, 0)
    cr:paint()
end

-- Créer un rectangle de base
local home_pane = wibox({
    visible = false,  -- Masqué par défaut
    ontop = true,     -- Toujours au-dessus
    width = 350,      -- Largeur du rectangle
    height = screen_height - 3 * border_size - wibar_height, -- Hauteur du rectangle avec bords et wibar
    bg = beautiful.bg_normal,
    shape = gears.shape.rounded_rect,     -- Forme arrondie
    opacity = 1       -- Opacité du rectangle
})

-- Appliquer l'effet de flou au fond du rectangle
home_pane:connect_signal("draw", function(self, cr, width, height)
    apply_blur(cr, width, height)
end)

-- Position initiale (hors écran à droite)
home_pane.x = screen_width
home_pane.y = border_size * 2 + wibar_height  -- Position verticale avec bord supérieur et wibar

-- Créer l'animation Rubato pour la position X
local x_anim = rubato.timed({
    duration = 0.5,      -- Durée de l'animation
    pos = home_pane.x, -- Position initiale (hors écran à droite)
    subscribed = function(pos)
        home_pane.x = pos -- Mise à jour de la position X du rectangle
    end
})

-- Fonction pour basculer l'affichage avec animation
function home_pane:toggle()
    if self.visible then
        -- Si visible, on anime la disparition vers la droite
        x_anim.target = screen_width
        
        -- Utiliser un timer pour cacher le rectangle après la fin de l'animation
        gears.timer.start_new(0.5, function()  -- Timer de 0.5 seconde (la durée de l'animation)
            self.visible = false  -- Masquer le rectangle après l'animation
        end)
    else
        -- Si invisible, rendre visible et animer vers la gauche
        self.visible = true
        -- Réinitialiser la position avant de commencer l'animation
        x_anim.target = screen_width - self.width - border_size  -- Position de destination proche du bord droit
    end
end



-- Fermer le rectangle lorsque l'on clique en dehors


return home_pane
