Activity {
	id: mainWindow;
	property bool portraitOrientation: false;
	anchors.fill: renderer;
	name: "root";

	Protocol { id: protocol; enabled: true; }

	ProvidersModel { id: providersModel; protocol: protocol; }

	CategoriesModel	{
		id: categoriesModel;
		protocol: protocol;
		provider: providersModel.defaultProvider;
	}

	EPGModel { id: epgModel; protocol: protocol; }

	ColorTheme { id: colorTheme; }

	VideoPlayer {
		id: videoPlayer;
		anchors.fill: renderer;
		source: "http://msk3.peers.tv/streaming/friday/126/tvrec/playlist.m3u8";
		autoPlay: true;

		//Preloader {
			//anchors.centerIn: videoPlayer;
			//visible: !videoPlayer.ready;
		//}
	}

	Item {
		id: osdLayout;
		anchors.fill: parent;
		opacity: protocol.loading ? 0.0 : 1.0;

		PageStack {
			id: content;
			anchors.top: parent.top;
			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.bottom: parent.bottom;
			anchors.leftMargin: menu.minWidth + 2;
			currentIndex: menu.currentIndex;

			WatchPage {
				onSwitched(channel): {
					log("Channel switched:", channel.text, "url:", channel.url)
					osdLayout.hide()
					videoPlayer.source = channel.url;
				}
			}

			//SettingsPage { }	//TODO: impl
			onLeftPressed: { menu.setFocus() }
		}

		MainMenu {
			id: menu;

			onRightPressed: { content.setFocus() }
		}
	
		hide: { this.visible = false }

		show: {
			this.visible = true
			menu.setFocus()
		}

		onBackPressed: { osdLayout.hide() }
	}

	Spinner { visible: protocol.loading; }

	onRedPressed: { osdLayout.show() }

	onBackPressed: {
		if (osdLayout.visible)
			return false

		// Crunch for compiler.
		if (!widgetAPI)
			var widgetAPI = { }
		if (_globals.core.vendor == "samsung")
			widgetAPI.sendExitEvent()
	}
}
