#!/usr/local/bin/perl

# yajb - Yet Another Juke Box. A program that, given the top directory of a
#		collection of music will find a .mp3  file at random then call
#		up mpg123 to play it. When mpg123 exits yajb will select another
#		song and call up mpg123 to play it -- and so on, and so on.
#		I'd like to get it to do more cool things as time goes by.
#		Right now it expects there to be a Genre/Artist/Album style
#		directory structure. I'd like to change that.

# Version 0.01
# Date Fri, Mar 31, 2000
# Version 0.02
# Date Fri, Mar 31, 2000 -- Ads no-repeat feature. But gives warnings with -w about uninit values.

# Variables and arrays.
#
$musicdirectory = "~/music/mps3s";		# This is the starting directory for music files.
$mpgplayer = "/usr/local/bin/mpg123";	# Which mpg player to use.
@choiceslist = ();						# Arrary to list files and directories to choose from.
$nextname = ""; 						# Used when reading directory and file names.
$numberofchoices = "";					# Used to hold to hold the number of choices in the choices list.
$numbertochoose = ""; 					# The number we have choose (directory or file).
$songtoplay = "";						# The name of the song chosen.
@songsplayed = ();						# An array holding a list of played songs.
# undef %songshash;						# Hash to lookup songs.
$truncatevalue = "50";					# When to truncate the list of played songs.
@dothis = ();							# The arguments to pass to the system call to play the song.

# Loop this
do {

# First - move to the base music directory.

chdir ($musicdirectory) || die "The music directory is unavailable! ($1)";

# Then - select a Genre.

@choiceslist = ();
while (defined ($nextname = <*>))
	{
	if (-d $nextname)
		{
		@choiceslist = (@choiceslist, $nextname);
		}
	}
$numberofchoices = (@choiceslist);
# All these print statements are for troubleshooting.
print "\nThe number of Genres is $numberofchoices\n";
$numbertochoose = int(rand ($numberofchoices));
print "\nThe number we have chosen is ($numbertochoose + 1)\n";
chdir ($choiceslist[$numbertochoose]) || die "Genre - something happened. ($1)";

# Then - select a Artist.

@choiceslist = ();
while (defined ($nextname = <*>))
	{
	if (-d $nextname)
		{
		@choiceslist = (@choiceslist, $nextname);
		}
	}
$numberofchoices = (@choiceslist);
print "\nThe number of Artists is $numberofchoices\n";
$numbertochoose = int(rand ($numberofchoices));
print "\nThe number we have chosen is ($numbertochoose + 1)\n";
chdir ($choiceslist[$numbertochoose]) || die "Artist - something happened. ($1)";

# Then - select an Album.

@choiceslist = ();
while (defined ($nextname = <*>))
	{
	if (-d $nextname)
		{
		@choiceslist = (@choiceslist, $nextname);
		}
	}
$numberofchoices = (@choiceslist);
print "\nThe number of Albums is $numberofchoices\n";
$numbertochoose = int(rand ($numberofchoices));
print "\nThe number we have chosen is ($numbertochoose + 1)\n";
chdir ($choiceslist[$numbertochoose]) || die "Album - something happened. ($1)";

# Then - select a Song.

@choiceslist = ();
while (defined ($nextname = <*.mp3>))
	{
	if (-r $nextname && -f $nextname)
		{
		@choiceslist = (@choiceslist, $nextname);
		}
	}
$numberofchoices = (@choiceslist);
print "\nThe number of Songs is $numberofchoices\n";
$numbertochoose = int(rand ($numberofchoices));
print "\nThe number we have chosen is ($numbertochoose + 1)\n";
$songtoplay = ($choiceslist[$numbertochoose]) || die "Song - something happened. ($1)";

# Then - play the song, as long as it isn't on the already played list.

undef %songshash;
for (@songsplayed)
	{
	$songshash{$_}=1;
	}

if (not ($songshash{$songtoplay}))
	{
	@dothis = ($mpgplayer, $songtoplay);
	@songsplayed = ($songtoplay, @songsplayed);
	print "\nThis is the list of songs played: @songsplayed\n";
	$#songsplayed = ($truncatevalue +1);
	system(@dothis);
	@dothis = ();
	}

} while 1 == 1; # Loop this forever, baby.
