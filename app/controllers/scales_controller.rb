class ScalesController < ApplicationController

  def home
  end

  def pitches
    @key = params[:key].capitalize
    @scale = params[:scale]
    @pattern = params[:pattern]

    load_keys

    (find_accidentals) if @scale != "chromatic"

    @sharp_key ? load_sharps : load_flats

    @i = 1

    # returns chromatic array for keys with sharps
    if @scale == "chromatic" && @chromatic_sharp_keys.include?(@key)
      load_sharps
      while @i < 12 do
        if @key_pos_sharp + @i < 12
          @scale_sharp.push(@all_sharp_notes[@key_pos_sharp + @i])
          @i += 1
        else
          @scale_sharp.push(@all_sharp_notes[@key_pos_sharp + @i - 12])
          @i += 1
        end
      end
      #render @scale_sharp
    end

    # returns chromatic array for keys with flats
    if @scale == "chromatic" && @chromatic_flat_keys.include?(@key)
      load_flats
      while @i < 12 do
        if @key_pos_flat + @i < 12
          @scale_flat.push(@all_flat_notes[@key_pos_flat + @i])
          @i += 1
        else
          @scale_flat.push(@all_flat_notes[@key_pos_flat + @i - 12])
          @i += 1
        end
      end
      #render @scale_flat
    end

    # returns array for non-chromatic scales with sharps
    if @scale != "chromatic" && @sharp_key
      while @i < @pattern_array.length do
        if @key_pos_sharp + @i < @pattern_array.length
          if @pattern_array[@i - 1] == "m"
            @scale_sharp.push(@all_sharp_notes[@key_pos_sharp + @i])
            @i += 1
          elsif @pattern_array[@i - 1] == "M"
            @scale_sharp.push(@all_sharp_notes[@key_pos_sharp + @i + 1])
            @key_pos_sharp +=1
            @i += 1
          elsif @pattern_array[@i - 1] == "A"
            @scale_sharp.push(@all_sharp_notes[@key_pos_sharp + @i + 2])
            @key_pos_sharp +=2
            @i += 1
          end
        else
          if @pattern_array[@i - 1] == "m"
            @scale_sharp.push(@all_sharp_notes[@key_pos_sharp + @i - 12])
            @i += 1
          elsif @pattern_array[@i - 1] == "M"
            @scale_sharp.push(@all_sharp_notes[@key_pos_sharp + @i + 1 - 12])
            @key_pos_sharp += 1
            @i += 1
          elsif @pattern_array[@i - 1] == "A"
            @scale_sharp.push(@all_sharp_notes[@key_pos_sharp + @i + 2 - 12])
            @key_pos_sharp += 2
            @i += 1
          end
        end
      end
      #render @scale_sharp
    end

    # returns array for non-chromatic scales with flats
    if @scale != "chromatic" && @sharp_key != true
      while @i < @pattern_array.length do
        if @key_pos_flat + @i < @pattern_array.length
          if @pattern_array[@i - 1] == "m"
            @scale_flat.push(@all_flat_notes[@key_pos_flat + @i])
            @i += 1
          elsif @pattern_array[@i - 1] == "M"
            @scale_flat.push(@all_flat_notes[@key_pos_flat + @i + 1])
            @key_pos_flat += 1
            @i += 1
          elsif @pattern_array[@i - 1] == "A"
            @scale_flat.push(@all_flat_notes[@key_pos_flat + @i + 2])
            @key_pos_flat += 2
            @i += 1
          end
        else
          if @pattern_array[@i - 1] == "m"
            @scale_flat.push(@all_flat_notes[@key_pos_flat + @i - 12])
            @i += 1
          elsif @pattern_array[@i - 1] == "M"
            @scale_flat.push(@all_flat_notes[@key_pos_flat + @i + 1 - 12])
            @key_pos_flat += 1
            @i += 1
          elsif @pattern_array[@i - 1] == "A"
            @scale_flat.push(@all_flat_notes[@key_pos_flat + @i + 2 - 12])
            @key_pos_flat += 2
            @i += 1
          end
        end
      end
      #render @scale_flat
    end

    render "home"
  end

  def load_keys
    @chromatic_sharp_keys = ["C", "G", "D", "A", "E", "B", "F#", "C#", "G#"]
    @chromatic_flat_keys = ["F", "Bb", "Eb", "Ab", "Db", "Gb"]
    @minor_sharp_keys = ["A", "E", "F#", "C#", "G#", "D#", "A#"]
    @minor_flat_keys = ["D", "G", "C", "F", "Bb", "Eb"]
    @octatonic_sharp_keys = ["C", "D#", "F#", "A"]
  end

  def find_accidentals
  (@pattern_array = @pattern.scan /\w/) if @scale != "chromatic"

  # finds if the pattern has a major or minor third
  if @pattern != nil
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
  if @third == 3 && @minor_flat_keys.include?(@key) && @scale != :octatonic
    @sharp_key = false
  elsif @third == 4 && @chromatic_flat_keys.include?(@key) && @scale != :octatonic
    @sharp_key = false
  elsif @octatonic_sharp_keys.include?(@key) && @scale == :octatonic
    @sharp_key = true
  else
    @sharp_key = true
  end
end

def load_sharps
  @all_sharp_notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
  @key_pos_sharp = @all_sharp_notes.find_index(@key)
  @scale_sharp = [@key]
end

def load_flats
  @all_flat_notes = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
  @key_pos_flat = @all_flat_notes.find_index(@key)
  @scale_flat = [@key]
end


  def name
    @key = params[:key].capitalize
    @scale = params[:scale]

    render "home"
  end




end
