ENT.Base            = "kbd_instrument_base"
ENT.Type            = "anim"
ENT.PrintName       = "MIDI Playable Piano"
ENT.Author          = "MacDGuy | Traducción para BlackBloodRP"
ENT.Purpose         = "A fully playable piano with MIDI input support"
ENT.Category        = "Fun + Games"
ENT.Spawnable       = true
ENT.AdminSpawnable  = true

ENT.Model           = Model("models/fishy/furniture/piano.mdl")
ENT.SoundDir        = "generic/instruments/piano/"

ENT.SoundNames = {
     "a1",  "b1",  "a2",  "b2",  "a3",  "a4",  "b3",  "a5",  "b4",  "a6",  "b5",  "a7",
     "a8",  "b6",  "a9",  "b7", "a10", "a11",  "b8", "a12",  "b9", "a13", "b10", "a14",
    "a15", "b11", "a16", "b12", "a17", "a18", "b13", "a19", "b14", "a20", "b15", "a21",
    "a22", "b16", "a23", "b17", "a24", "a25", "b18", "a26", "b19", "a27", "b20", "a28",
    "a29", "b21", "a30", "b22", "a31", "a32", "b23", "a33", "b24", "a34", "b25", "a35",
    "a36"
}

ENT.SemitonesNum = #ENT.SoundNames

local darker = Color(100, 100, 100, 150)
ENT.Keys = {
    [KEY_A] = { Semitone = 25, Material = "left", Label = "A", X = 19, Y = 86 },
    [KEY_S] = { Semitone = 27, Material = "middle", Label = "S", X = 44, Y = 86 },
    [KEY_D] = { Semitone = 29, Material = "right", Label = "D", X = 68, Y = 86 },
    [KEY_F] = { Semitone = 30, Material = "left", Label = "F", X = 94, Y = 86 },
    [KEY_G] = { Semitone = 32, Material = "leftmid", Label = "G", X = 119, Y = 86 },
    [KEY_H] = { Semitone = 34, Material = "rightmid", Label = "H", X = 144, Y = 86 },
    [KEY_J] = { Semitone = 36, Material = "right", Label = "J", X = 169, Y = 86 },
    [KEY_K] = { Semitone = 37, Material = "left", Label = "K", X = 194, Y = 86 },
    [KEY_L] = { Semitone = 39, Material = "middle", Label = "L", X = 219, Y = 86 },
    [KEY_SEMICOLON] = { Semitone = 41, Material = "right", Label = ":", X = 244, Y = 86 },
    [KEY_APOSTROPHE] = { Semitone = 42, Material = "full", Label = "'", X = 269, Y = 86 },

    [KEY_W] = { Semitone = 26, Material = "top", Label = "W", X = 33, Y = 31, TextX = 7, TextY = 90, Color = darker },
    [KEY_E] = { Semitone = 28, Material = "top", Label = "E", X = 64, Y = 31, TextX = 7, TextY = 90, Color = darker },
    [KEY_T] = { Semitone = 31, Material = "top", Label = "T", X = 108, Y = 31, TextX = 7, TextY = 90, Color = darker },
    [KEY_Y] = { Semitone = 33, Material = "top", Label = "Y", X = 136, Y = 31, TextX = 7, TextY = 90, Color = darker },
    [KEY_U] = { Semitone = 35, Material = "top", Label = "U", X = 164, Y = 31, TextX = 7, TextY = 90, Color = darker },
    [KEY_O] = { Semitone = 38, Material = "top", Label = "O", X = 208, Y = 31, TextX = 7, TextY = 90, Color = darker },
    [KEY_P] = { Semitone = 40, Material = "top", Label = "P", X = 239, Y = 31, TextX = 7, TextY = 90, Color = darker },
}

ENT.AdvancedKeys = {
    [KEY_1] =
    {
        Semitone = 1, Material = "left", Label = "1", X = 19, Y = 86,
        Shift = { Semitone = 2, Material = "top", Label = "!", X = 33, Y = 31, TextX = 7, TextY = 90, Color = darker },
    },
    [KEY_2] =
    {
        Semitone = 3, Material = "middle", Label = "2", X = 44, Y = 86,
        Shift = { Semitone = 4, Material = "top", Label = "@", X = 64, Y = 31, TextX = 7, TextY = 90, Color = darker },
    },
    [KEY_3] = { Semitone = 5, Material = "right", Label = "3", X = 69, Y = 86 },
    [KEY_4] =
    {
        Semitone = 6, Material = "left", Label = "4", X = 94, Y = 86,
        Shift = { Semitone = 7, Material = "top", Label = "$", X = 108, Y = 31, TextX = 7, TextY = 90, Color = darker },
    },
    [KEY_5] =
    {
        Semitone = 8, Material = "leftmid", Label = "5", X = 119, Y = 86,
        Shift = { Semitone = 9, Material = "top", Label = "%", X = 136, Y = 31, TextX = 7, TextY = 90, Color = darker },
    },
    [KEY_6] =
    {
        Semitone = 10, Material = "rightmid", Label = "6", X = 144, Y = 86,
        Shift = { Semitone = 11, Material = "top", Label = "^", X = 164, Y = 31, TextX = 7, TextY = 90, Color = darker },
    },
    [KEY_7] = { Semitone = 12, Material = "right", Label = "7", X = 169, Y = 86 },
    [KEY_8] =
    {
        Semitone = 13, Material = "left", Label = "8", X = 194, Y = 86,
        Shift = { Semitone = 14, Material = "top", Label = "*", X = 208, Y = 31, TextX = 7, TextY = 90, Color = darker },
    },
    [KEY_9] =
    {
        Semitone = 15, Material = "middle", Label = "9", X = 219, Y = 86,
        Shift = { Semitone = 16, Material = "top", Label = "(", X = 239, Y = 31, TextX = 7, TextY = 90, Color = darker },
    },
    [KEY_0] = { Semitone = 17, Material = "right", Label = "0", X = 244, Y = 86 },
    [KEY_Q] =
    {
        Semitone = 18, Material = "left", Label = "q", X = 269, Y = 86,
        Shift = { Semitone = 19, Material = "top", Label = "Q", X = 283, Y = 31, TextX = 7, TextY = 90, Color = darker },
    },
    [KEY_W] =
    {
        Semitone = 20, Material = "leftmid", Label = "w", X = 294, Y = 86,
        Shift = { Semitone = 21, Material = "top", Label = "W", X = 310, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 310
    [KEY_E] =
    {
        Semitone = 22, Material = "rightmid", Label = "e", X = 319, Y = 86,
        Shift = { Semitone = 23, Material = "top", Label = "E", X = 339, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 339
    [KEY_R] = { Semitone = 24, Material = "right", Label = "r", X = 344, Y = 86 },
    [KEY_T] =
    {
        Semitone = 25, Material = "left", Label = "t", X = 369, Y = 86,
        Shift = { Semitone = 26, Material = "top", Label = "T", X = 383, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 383
    [KEY_Y] =
    {
        Semitone = 27, Material = "middle", Label = "y", X = 394, Y = 86,
        Shift = { Semitone = 28, Material = "top", Label = "Y", X = 414, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 415
    [KEY_U] = { Semitone = 29, Material = "right", Label = "u", X = 419, Y = 86 },
    [KEY_I] =
    {
        Semitone = 30, Material = "left", Label = "i", X = 444, Y = 86,
        Shift = { Semitone = 31, Material = "top", Label = "I", X = 458, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 459
    [KEY_O] =
    {
        Semitone = 32, Material = "leftmid", Label = "o", X = 469, Y = 86,
        Shift = { Semitone = 33, Material = "top", Label = "O", X = 486, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 486
    [KEY_P] =
    {
        Semitone = 34, Material = "rightmid", Label = "p", X = 494, Y = 86,
        Shift = { Semitone = 35, Material = "top", Label = "P", X = 514, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 515
    [KEY_A] = { Semitone = 36, Material = "right", Label = "a", X = 519, Y = 86 },
    [KEY_S] =
    {
        Semitone = 37, Material = "left", Label = "s", X = 544, Y = 86,
        Shift = { Semitone = 38, Material = "top", Label = "S", X = 558, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 559
    [KEY_D] =
    {
        Semitone = 39, Material = "middle", Label = "d", X = 569, Y = 86,
        Shift = { Semitone = 40, Material = "top", Label = "D", X = 590, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 590
    [KEY_F] = { Semitone = 41, Material = "right", Label = "f", X = 594, Y = 86 },
    [KEY_G] =
    {
        Semitone = 42, Material = "left", Label = "g", X = 619, Y = 86,
        Shift = { Semitone = 43, Material = "top", Label = "G", X = 633, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 633
    [KEY_H] =
    {
        Semitone = 44, Material = "leftmid", Label = "h", X = 644, Y = 86,
        Shift = { Semitone = 45, Material = "top", Label = "H", X = 661, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 661
    [KEY_J] =
    {
        Semitone = 46, Material = "rightmid", Label = "j", X = 669, Y = 86,
        Shift = { Semitone = 47, Material = "top", Label = "J", X = 690, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 690
    [KEY_K] = { Semitone = 48, Material = "right", Label = "k", X = 694, Y = 86 },
    [KEY_L] =
    {
        Semitone = 49, Material = "left", Label = "l", X = 719, Y = 86,
        Shift = { Semitone = 50, Material = "top", Label = "L", X = 734, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 734
    [KEY_Z] =
    {
        Semitone = 51, Material = "middle", Label = "z", X = 744, Y = 86,
        Shift = { Semitone = 52, Material = "top", Label = "Z", X = 765, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 765
    [KEY_X] = { Semitone = 53, Material = "right", Label = "x", X = 769, Y = 86 },
    [KEY_C] =
    {
        Semitone = 54, Material = "left", Label = "c", X = 794, Y = 86,
        Shift = { Semitone = 55, Material = "top", Label = "C", X = 809, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 809
    [KEY_V] =
    {
        Semitone = 56, Material = "leftmid", Label = "v", X = 819, Y = 86,
        Shift = { Semitone = 57, Material = "top", Label = "V", X = 837, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 837
    [KEY_B] =
    {
        Semitone = 58, Material = "rightmid", Label = "b", X = 844, Y = 86,
        Shift = { Semitone = 59, Material = "top", Label = "B", X = 865, Y = 31, TextX = 7, TextY = 90, Color = darker },
    }, // 865
    [KEY_N] = { Semitone = 60, Material = "right", Label = "n", X = 869, Y = 86 },
    [KEY_M] = { Semitone = 61, Material = "full", Label = "m", X = 894, Y = 86 },
}
