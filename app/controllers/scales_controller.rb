class ScalesController < ApplicationController

  def home
  end

  def pitches
    @key = params[:key].capitalize
    @scale = params[:scale]
    @i = 1

    load_keys
    (find_pattern) if @scale != "chromatic"
    (find_accidentals) if @scale != "chromatic"

    if @chromatic_sharp_keys.include?(@key) || @sharp_key
      load_sharps
    else
      load_flats
    end

    if @scale == "chromatic"
      while @i < 12 do
        if @key_pos + @i < 12
          @scale_build.push(@all_notes[@key_pos + @i])
          @i += 1
        else
          @scale_build.push(@all_notes[@key_pos + @i - 12])
          @i += 1
        end
      end
    end

    if @scale != "chromatic"
      while @i < @pattern_array.length do
        if @key_pos + @i < @pattern_array.length
          if @pattern_array[@i - 1] == "m"
            @scale_build.push(@all_notes[@key_pos + @i])
            @i += 1
          elsif @pattern_array[@i - 1] == "M"
            @scale_build.push(@all_notes[@key_pos + @i + 1])
            @key_pos +=1
            @i += 1
          elsif @pattern_array[@i - 1] == "A"
            @scale_build.push(@all_notes[@key_pos + @i + 2])
            @key_pos +=2
            @i += 1
          end
        else
          if @pattern_array[@i - 1] == "m"
            @scale_build.push(@all_notes[@key_pos + @i - 12])
            @i += 1
          elsif @pattern_array[@i - 1] == "M"
            @scale_build.push(@all_notes[@key_pos + @i + 1 - 12])
            @key_pos += 1
            @i += 1
          elsif @pattern_array[@i - 1] == "A"
            @scale_build.push(@all_notes[@key_pos + @i + 2 - 12])
            @key_pos += 2
            @i += 1
          end
        end
      end
    end
    capitalize_scale_names
    render "home"
  end

  def load_keys
    @chromatic_sharp_keys = ["A", "B", "C", "C#", "D", "E", "F#", "G", "G#"]
    @chromatic_flat_keys = ["Ab", "Bb", "Db", "Eb", "F", "Gb"]
    @minor_sharp_keys = ["A", "B", "C#", "E", "F#", "G#"]
    @minor_flat_keys = ["Ab", "Bb", "C", "Db", "D", "Eb", "F", "G", "Gb"]
    @octatonic_flat_keys = ["Ab", "Bb", "Db", "Eb", "F", "Gb"]
  end

  def find_pattern
    @pattern = "MMmMMMm" if @scale == "major"
    @pattern = "MmMMmMM" if @scale == "minor"
    @pattern = "MmMMMmM" if @scale == "dorian"
    @pattern = "MMmMMmM" if @scale == "mixolydian"
    @pattern = "MMMmMMm" if @scale == "lydian"
    @pattern = "mMMMmMM" if @scale == "phrygian"
    @pattern = "mMMmMMM" if @scale == "locrian"
    @pattern = "MmMMmAm" if @scale == "harmonic_minor"
    @pattern = "MmMmMmMm" if @scale == "octatonic"
    @pattern = "MMMMMM" if @scale == "hexatonic"
    @pattern = "MMAMA" if @scale == "major_pentatonic"
    @pattern = "AMMAM" if @scale == "minor_pentatonic"
    @pattern = "mAMMMmM" if @scale == "enigma"
  end

  def find_accidentals
  @pattern_array = @pattern.scan /\w/

    # finds if the pattern has a major or minor third
    if @pattern
      @third = 0
      case @pattern_array[0]
      when "m"
        @third += 1
      when "M"
        @third += 2
      when "A"
        @third += 3
      end

      case @pattern_array[1]
      when "m"
        @third += 1
      when "M"
        @third += 2
      when "A"
        @third += 3
      end
    end

    # finds if the scale uses sharps or flats
    if @third == 3 && @minor_flat_keys.include?(@key) && @scale != "octatonic"
      @sharp_key = false
    elsif @third == 4 && @chromatic_flat_keys.include?(@key) && @scale != "octatonic"
      @sharp_key = false
    elsif @scale == "octatonic" && @octatonic_flat_keys.include?(@key)
      @sharp_key = false
    else
      @sharp_key = true
    end
  end

  def load_sharps
    @all_notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    @key_pos = @all_notes.find_index(@key)
    @scale_build = [@key]
    (@sharp_key = true) if @sharp_key == nil
  end

  def load_flats
    @all_notes = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    @key_pos = @all_notes.find_index(@key)
    @scale_build = [@key]
    (@sharp_key = false) if @sharp_key == nil
  end

  def capitalize_scale_names
    case @scale
    when "harmonic_minor"
      @scale = "Harmonic Minor"
    when "major_pentatonic"
      @scale = "Major Pentatonic"
    when "minor_pentatonic"
      @scale = "Minor Pentatonic"
    else
      @scale = @scale.capitalize
    end
  end
end
