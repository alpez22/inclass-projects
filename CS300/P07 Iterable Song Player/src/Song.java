//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Song
// Course: CS 300 Spring 2022
//
// Author: Ava Pezza
// Email: apezza@wisc.edu
// Lecturer: Hobbes LeGault
//
///////////////////////// ALWAYS CREDIT OUTSIDE HELP //////////////////////////
//
// Persons: none
// Online Sources: none
//
///////////////////////////////////////////////////////////////////////////////

/**
 *This class models a song
 */
public class Song {

  private String songName; // name or title of the song
  private String artist; // artist of the song
  private String duration; // duration of the song

  /**
   * Creates a new Song given the song name, the name of the artist, and the duration of the song
   * 
   * @param songName title of the song
   * @param artist   name of the artist who performed this song
   * @param duration duration of the song in the format mm:ss
   * @throws IllegalArgumentException with a descriptive error message if either of songName, or
   *                                  artist, or duration is null or is blank, or if the duration is
   *                                  not formatted as mm:ss where both mm and ss are in the 0 .. 59
   *                                  range.
   */
  public Song(String songName, String artist, String duration) {
    try {
    if (this.duration != null) {
      String[] format = duration.split(":");
      //String format = arrOfStr[0] + ":" + arrOfStr[1];
      if (songName == null || songName.equals("") || artist == null || artist.equals("")
          || (Integer.parseInt(format[0])) % 60 != Integer.parseInt(format[0])
          || (Integer.parseInt(format[1])) % 60 != Integer.parseInt(format[1])) {
        throw new IllegalArgumentException(
            "Error: param is null OR duration is not formatted correctly");
      }
    }
    }catch(Exception e) {
      System.out.println("Error");
    }
    this.songName = songName;
    this.artist = artist;
    this.duration = duration;
  }

  public String getSongName() {
    return this.songName;
  }

  public String getArtist() {
    return this.artist;
  }

  public String getDuration() {
    return this.duration;
  }

  @Override
  public String toString() {
    String songFormat = getSongName() + "---" + getArtist() + "---" + getDuration();
    return songFormat;
  }

  /**
   * Returns true when this song's name and artist strings equals to the other song's name and
   * artist strings, and false otherwise. Note that this method takes an Object rather than a Song
   * argument, so that it Overrides Object.equals(Object). If an object that is not an instance of
   * Song is ever passed to this method, it should return false.
   * 
   * @param other Song object to compare this object to
   * @return true when the this song has matching name and artist with respect to another song (case
   *         insensitive comparison)
   */
  @Override
  public boolean equals(Object other) {
    if(other == null) {
      return false;
    }
    if (other instanceof Song) {  
      Song otherSong = (Song) other;
      if (otherSong.getArtist().equalsIgnoreCase(this.getArtist())
          && otherSong.getSongName().equalsIgnoreCase(this.getSongName())) {
        return true;
      }
    }
    return false;
  }
}
