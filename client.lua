-- Removes the farm-fence prop that sits in train-station platforms.
-- prop_fnc_farm_01f is BASE-GAME world geometry (no map resource spawns it),
-- so DeleteObject won't stick - CreateModelHide is the native that actually
-- removes/hides map objects by model in a radius (persistent for the session).

-- The farm fence has several variants (01a..01f) scattered through station
-- platforms (Sandy saw 01e, others 01f). Hide the whole family.
local TARGETS = {
    `prop_fnc_farm_01a`, `prop_fnc_farm_01b`, `prop_fnc_farm_01c`,
    `prop_fnc_farm_01d`, `prop_fnc_farm_01e`, `prop_fnc_farm_01f`,
}

local STATIONS = {
    vec3(-446.82, 5362.51, 80.67),  -- Lumber Mill
    vec3(111.85,  6317.60, 30.69),  -- Paleto Bay
    vec3(2599.30, 2912.57, 38.57),  -- Quarry
    vec3(2450.27, 2482.35, 41.07),  -- Wind Farm
    vec3(2610.99, 1649.71, 26.62),  -- Power Plant
    vec3(669.27, -1104.79, 22.74),  -- Downtown
    vec3(217.43, -2436.63, 6.21),   -- Port Depot
    vec3(1870.67, 3544.59, 37.67),  -- Sandy Shores Depot
}

local function hideAt(c, radius)
    -- CreateModelHide(x, y, z, radius, modelHash, network) - hides base-game
    -- map objects of that model in the radius. Runs on the client that's there.
    for i = 1, #TARGETS do
        CreateModelHide(c.x + 0.0, c.y + 0.0, c.z + 0.0, radius or 50.0, TARGETS[i], true)
    end
end

CreateThread(function()
    for i = 1, #STATIONS do
        local s = STATIONS[i]
        -- fire immediately in case the player is already at this station,
        -- and again whenever they enter/are near (ox_lib point, not a poll).
        lib.points.new({
            coords = s,
            distance = 120.0,
            onEnter = function() hideAt(s) end,
            nearby = function(self)
                if not self.hidden then hideAt(s); self.hidden = true end
            end,
        })
    end
end)

-- Manual trigger: stand next to the fence and run /clearfence
RegisterCommand('clearfence', function()
    local c = GetEntityCoords(PlayerPedId())
    hideAt(c, 40.0)
    print('^2[stationclear] hid prop_fnc_farm_01f within 40m^7')
end, false)

-- Area hides: map props to remove within a radius of a point (same native as above).
-- Mirror Park Raceway: custom light poles (zc_prop_ind_light_02b_def) planted on the track.
-- The model is placed by a packed map archive, so a hide is the server-side fix.
local AREAS = {
    { label = "Mirror Park Raceway light poles", coords = vec3(1123.45, -1234.56, 42.10), radius = 250.0,
      models = { 709190416 --[[ zc_prop_ind_light_02b_def ]] } },
    -- Roxwood Junction corridor (Damon, 2026-09-21: "clear all of those within
    -- that general area ... along the train tracks and roadways"). Three
    -- overlapping 70m sweeps follow the rails/road east from the junction and
    -- take out every cedar/sequoia in the corridor, instead of one hide per tree.
    { label = "Roxwood Junction corridor W (junction + bridge)", coords = vec3(800.00, 6460.00, 31.00), radius = 70.0,
      models = { `prop_tree_cedar_02`, `onx_sequoia_02_a`, `onx_sequoia_01_a`, `prop_w_r_cedar_01`, `prop_tree_birch_04`, `onx_sequoia_02_b` } },
    { label = "Roxwood Junction corridor C", coords = vec3(880.00, 6490.00, 28.00), radius = 70.0,
      models = { `prop_tree_cedar_02`, `onx_sequoia_02_a`, `onx_sequoia_01_a`, `prop_w_r_cedar_01`, `prop_tree_birch_04`, `onx_sequoia_02_b` } },
    { label = "Roxwood Junction corridor E", coords = vec3(960.00, 6495.00, 24.00), radius = 70.0,
      models = { `prop_tree_cedar_02`, `onx_sequoia_02_a`, `onx_sequoia_01_a`, `prop_w_r_cedar_01`, `prop_tree_birch_04`, `onx_sequoia_02_b` } },
    -- Damon, 2026-09-23: a huge sequoia at -540.81, 6271.71, "we have two in
    -- that general area". 40m sweep so both go, rather than one hide per tree.
    { label = "Lone sequoias west of Roxwood", coords = vec3(-540.81, 6271.71, 8.12), radius = 40.0,
      models = { `onx_sequoia_01_a`, `prop_tree_cedar_02` } },
    -- Damon, 2026-09-26: vanilla construction lift still standing inside the Rags-n-Riches
    -- LS Live block after the 1.6.0 install ("prop_conslift_lift @ -182.22 -1016.44 31.37").
    { label = "LS Live leftover construction lift", coords = vec3(-182.22, -1016.44, 31.37), radius = 15.0,
      models = { `prop_conslift_lift` } },
    -- Damon, 2026-09-26: ghost containers of the old construction site under the Rags-n-Riches
    -- tower (six /spot marks, x -90..-140, y -935..-1060). Rags 1.6.0 empties the close-up
    -- entities of block dt1_21 but its LOD map still places the block distant model
    -- dt1_lod_21 (hash 3320779646), which the game then draws up close. Hide that model.
    { label = "LS Live old construction site distant model", coords = vec3(-156.5, -1042.7, 42.2), radius = 200.0,
      models = { `dt1_lod_21` } },
    -- Damon, 2026-09-26: the actual ghost containers. The base-game file dt1_21_critical_0.ymap
    -- (x64i.rpf, not the hei_ version Rags empties) places model 3235189104 sixteen times around
    -- the old construction site perimeter, x -60..-230, y -926..-1112. Hide it by hash.
    { label = "LS Live old construction site containers", coords = vec3(-150.0, -1015.0, 27.0), radius = 220.0,
      models = { -1059778192 --[[ 3235189104, base dt1_21_critical_0 ]] } },
    -- Damon, 2026-09-26: still-visible ghosts at the old site after the base files were emptied.
    -- Every ground-level model the vanilla dt1_21 / dt1_21_long_0 files place inside the footprint
    -- (x -145..-55, y -1100..-925), hidden by hash so no copy from any source can draw them.
    { label = "LS Live old construction site, all vanilla ground models", coords = vec3(-120.0, -1010.0, 30.0), radius = 250.0,
      models = { -1480350485, -350958032, -674724219, -1761765122, 2093204297, 932133798, -1729755864, 181142258, 1986177295, 1019136610, -1320522612, 189874284, 1147611394, -584906966, -225322091, 1400979791, -293889843, 1704776920, -22983974, -369949851, -1003140932, -1510214055, -679820683, 701324079, -1159699521, -2038628351 } },
}
local function hideArea(a)
    for i = 1, #a.models do
        CreateModelHide(a.coords.x + 0.0, a.coords.y + 0.0, a.coords.z + 0.0, a.radius, a.models[i], true)
    end
end
CreateThread(function()
    for i = 1, #AREAS do
        local a = AREAS[i]
        lib.points.new({
            coords = a.coords,
            distance = a.radius + 200.0,
            onEnter = function() hideArea(a) end,
            nearby = function(self)
                if not self.hidden then hideArea(a); self.hidden = true end
            end,
        })
    end
end)

-----------------------------------------------------------
-- PED BLOCKS (DPS 2026-09-27): stop the game's ambient scenario peds spawning on a spot
-- our AI NPCs stand on (Damon: a vanilla pilot kept spawning beside Captain Marcus at
-- LSIA). AddScenarioBlockingArea is a client native that removes the scenario points
-- inside a box; our own peds are script peds and are not touched. Armed by lib.points,
-- released again when the player leaves, no polling.
-----------------------------------------------------------
local PED_BLOCKS = {
    { label = "LSIA terminal desk (Captain Marcus)", coords = vec3(-1037.44, -2736.91, 20.17), radius = 14.0 },
}
CreateThread(function()
    for i = 1, #PED_BLOCKS do
        local b = PED_BLOCKS[i]
        lib.points.new({
            coords = b.coords,
            distance = b.radius + 150.0,
            onEnter = function(self)
                if self.blockId then return end
                local c, r = b.coords, b.radius
                self.blockId = AddScenarioBlockingArea(c.x - r, c.y - r, c.z - 10.0, c.x + r, c.y + r, c.z + 10.0, false, true, true, true)
            end,
            onExit = function(self)
                if self.blockId then
                    RemoveScenarioBlockingArea(self.blockId, false)
                    self.blockId = nil
                end
            end,
        })
    end
end)
