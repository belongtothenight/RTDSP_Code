function [info, audio, sampleRate] = readAudio(path)

    info = audioinfo(path);
    audio = audioread(path);
    sampleRate = info.SampleRate;

end

