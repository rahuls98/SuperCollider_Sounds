s.boot;

MIDIIn.connectAll;
// MIDIClient.init;

(
// A SynthDef with ADSR envelope
SynthDef("quick2", {arg freq = 440, amp = 0.1, gate = 1;
	var snd, env;
	env = Env.adsr(0.01, 0.1, 0.3, 2, amp).kr(2, gate);
	snd = Saw.ar(freq: [freq, freq*1.5], mul: env);
	Out.ar(0, snd)
}).add;
)

// Play it with a MIDI keyboard
(
var noteArray = Array.newClear(128); // array has one slot per possible MIDI note

MIDIdef.noteOn(\myKeyDown, {arg vel, note;
	noteArray[note] = Synth("quick2", [\freq, note.midicps, \amp, vel.linlin(0, 127, 0, 1)]);
	["NOTE ON", note].postln;
});

MIDIdef.noteOff(\myKeyUp, {arg vel, note;
	noteArray[note].set(\gate, 0);
	["NOTE OFF", note].postln;
});
)
// PS. Make sure SC MIDI connections are made (MIDIIn.connectAll)

