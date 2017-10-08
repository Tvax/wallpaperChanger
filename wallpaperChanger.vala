void changeWallpaper(){
  var uri = "https://api.unsplash.com/photos/random?query=nature";
  var session = new Soup.Session ();
  var message = new Soup.Message ("GET", uri);
  message.request_headers.append("Authorization", "Bearer d1d21525dd7d52dc4f608a06c458031ac4a427cc06de40b347eb90802a1d1fa7");
  session.send_message (message);

  try {
    var parser = new Json.Parser ();
    parser.load_from_data ((string) message.response_body.flatten ().data, -1);
    var root_object = parser.get_root ().get_object ();
    var response = root_object.get_object_member ("urls");
    var results = response.get_string_member ("raw");

    var src = File.new_for_uri (results);
    var dst = File.new_for_path ("/tmp/wallpaper.jpg");
    try {
      Process.spawn_command_line_async("rm /tmp/wallpaper.jpg");
      src.copy (dst, FileCopyFlags.NONE, null, null);
    }catch (Error e) {
      stderr.printf ("%s\n", e.message);
    }

  Process.spawn_command_line_async("gsettings set org.gnome.desktop.background picture-uri file:/tmp/wallpaper.jpg");

  }catch (Error e) {
    stderr.printf ("%s\n", e.message);
  }
}

int main(string []args){
  Gtk.init(ref args);

  var header = new Gtk.HeaderBar();
  header.set_show_close_button(true);
  header.set_title("Wallpaper Changer");

  var window = new Gtk.Window();
  window.set_titlebar(header);
  window.destroy.connect(Gtk.main_quit);
  window.set_default_size(400, 70);
  window.border_width = 10;
  window.window_position = Gtk.WindowPosition.CENTER;

  var button = new Gtk.Button.with_label("Change Wallpaper");
  button.clicked.connect (() => {
    changeWallpaper();
  });

  window.add(button);
  window.show_all();

  Gtk.main();
  return 0;

}
