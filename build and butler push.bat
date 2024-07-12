E:\godotwithoutnet\Godot_v4.2.2-stable_win64_console.exe --headless --export-release Web ./build/web/index.html
butler push ./build/web dnevill/lydlbujam71:html5
timeout 10
butler status dnevill/lydlbujam71:html5
@pause