--Values of fx: noiz(0,1),buzz(0,1),detune(0,1,2),reverb(0,1,2),dampen(0,1,2)
function make_globalfx(noiz,buzz,detune,reverb,dampen)
 local effect = 0
 effect |= noiz and 2 or 0
 effect |= buzz and 4 or 0
 effect += detune * 8
 effect += reverb * 24
 effect += dampen * 72
 return effect
end

function set_globalfx(sfx_index,effect)
 local addr=0x3200+68*sfx_index
 poke(addr+64,effect)
end


function play_type_sfx(sfx_id, note_pos, type)
  -- 0x3200 is the start of SFX data
  -- Each sfx is 68 bytes. Each note is 2 bytes.
  -- 0x3200 + (sfx_id * 68) + (note_pos * 2) + 1 (instrument byte)

  local addr = 0x3200 + (sfx_id * 68) + (note_pos * 2) 
  local val = peek2(addr)  -- save original instrument
 
  local note1 = 0x3200 + 30 * 68 + 0 
  local note2 = 0x3200 + 30 * 68 + 2

  local sfx_id

  if type == "fire" then
	-- this sets instrument 110 (6) for fire
	val = (val & ~(0b111 << 6)) | (0b110 << 6)
	-- effect bits 12..14 = 011
	val = (val & ~(0b111 << 12)) | (0b011 << 12)

    poke2(note1, val + 0b00000111)  -- adding 7 to the makes it one scale higher because the 5 first bits correspond to the pitch
  	poke2(note2, val)
    -- sets noise buzz and dampen for the effect 
  	set_globalfx(30, make_globalfx(1,0,0,0,2)) 
  elseif type == "water" then
    val = (val & ~(0b111 << 6)) | (0b111 << 6) 
    val = (val & ~(0b111 << 12)) | (0b001 << 12)
    poke2(note1, val)
    val = (val & ~(0b111 << 12)) | (0b110 << 12)
    poke2(note2, val + 0b00000111)  -- adding 7 to the makes it one scale higher because the 5 first bits correspond to the pitch
    set_globalfx(30, make_globalfx(0,0,0,2,2))
    elseif type == "plant" then
    end
  -- play the modified note
  sfx(30, 2, 0, 2) 
end