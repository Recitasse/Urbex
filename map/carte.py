import folium


class Carte:
    def __init__(self) -> None:
        self.map = folium.Map(location=[], zoom_start=12)

