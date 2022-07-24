namespace Controls
{
	void PluginCard(PluginInfo@ plugin, float width)
	{
		UI::PushID(plugin);

		vec2 windowPos = UI::GetWindowPos();
		vec2 imagePos = UI::GetCursorPos();
		imagePos.y -= UI::GetScrollY(); // GetCursorPos doesn't include the scrolling offset

		auto img = Images::CachedFromURL(plugin.m_image);
		float imgHeight;
		if (img.m_texture !is null) {
			vec2 thumbSize = img.m_texture.GetSize();
			imgHeight = thumbSize.y / (thumbSize.x / width);
			UI::Image(img.m_texture, vec2(width, imgHeight));
		} else {
			const float EXTRA_PIXELS = 6.0f;
			imgHeight = 270.0f / (480.0f / width) + EXTRA_PIXELS;
			UI::SetCursorPos(UI::GetCursorPos() + vec2(0, imgHeight));
		}

		// Draw an installed tag on top of the image if it's installed
		if (plugin.GetInstalledPlugin() !is null) {
			vec2 tagPos = windowPos + imagePos + vec2(6, 6);
			DrawTag(tagPos, Icons::CheckCircle + " Installed", Controls::TAG_COLOR_PRIMARY);

			// Draw an updatable tag on top of the image if it's installed and updatable
			if (GetAvailableUpdate(plugin.m_siteID) !is null) {
				tagPos = windowPos + imagePos + vec2(6, 36);
				DrawTag(tagPos, Icons::ArrowCircleUp + " Update!", Controls::TAG_COLOR_WARNING);
			}
		}

		// Remember where our text will go
		vec2 textPos = UI::GetCursorPos();

		UI::Text(plugin.m_name);
		UI::TextDisabled("By " + TransformUsername(plugin.m_author));

		UI::SetCursorPos(imagePos);
		if (UI::InvisibleButton("##" + plugin.m_id + "-mclick-new-tab", vec2(width, imgHeight), UI::ButtonFlags::MouseButtonMiddle)) {
			g_window.AddTab(PluginTab(plugin.m_siteID));
		}

		UI::SetCursorPos(textPos + vec2(width - 40, 5));
		if (UI::Button("Info")) {
			g_window.AddTab(PluginTab(plugin.m_siteID), true);
		}

		UI::PopID();
	}
}
