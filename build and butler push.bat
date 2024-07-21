E:\godotwithoutnet\Godot_v4.2.2-stable_win64_console.exe --headless --export-release Web ./build/web/index.html
butler push ./build/web dnevill/croakanole:html5
timeout 10
butler status dnevill/croakanole:html5
@pause