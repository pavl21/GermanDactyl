[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<p align="center">
  <a href="https://github.com/pavl21/GermanDactyl">
    <img src="https://raw.githubusercontent.com/pavl21/GermanDactyl/main/docs/assets/images/logo.png" alt="Logo" width="80" height="80">
  </a>
</p>
<h3 align="center">GermanDactyl</h3>

## Was ist GermanDactyl?

GermanDactyl ist die deutsche Übersetzung des [Pterodactyl Panels](https://pterodactyl.io/). Deutsch wird dabei als eigene Sprache (`resources/lang/de`) hinzugefügt, Englisch bleibt erhalten.

## Wie installiere ich das?

Ganz einfach:

```shell
curl -fsSL https://install.germandactyl.de/ | sudo bash -s --
```

Der Installer erstellt vorher ein Backup, wendet den passenden Patch an und baut das Panel neu. Optionen (`-d`, `-v`, `-y`, `-u`, `-h`) und Voraussetzungen findest du in der [Dokumentation](https://germandactyl.de/installation/).

### GermanDactyl Setup

Du hast noch kein Panel? Dann nimm das Setup:

```shell
sudo bash -c "$(curl -fsSL https://setup.germandactyl.de/)"
```

Es installiert Panel, Wings und die Übersetzung komplett über eine Textoberfläche. Die Anleitung findest du unter https://germandactyl.de/guides/setup/.

## Unterstützte Versionen

Aktuelle Panel-Version: **v1.15.1**

| Pterodactyl Panel | GermanDactyl-Patch |
| --- | --- |
| 1.11.2 | v1.11.2 |
| 1.11.3 | v1.11.3 |
| 1.12.2 | v1.12.2 |
| 1.13.x, 1.14.x, 1.15.0 | kein eigener Patch – bitte auf 1.15.1 aktualisieren |
| 1.15.1 | v1.15.1 |

## Discord

Wenn du uns beim Übersetzen oder Umformulieren helfen möchtest, komm gerne [in unseren Discord](https://discord.gg/6R38NnTCct). Wie du Übersetzungen direkt per Pull Request einreichst, steht [in der Anleitung](https://germandactyl.de/guides/contribute/).

## Lizenz

Verbreitet unter der MIT-Lizenz. Siehe [`LICENSE`](LICENSE) für weitere Informationen.

[contributors-shield]: https://img.shields.io/github/contributors/pavl21/GermanDactyl.svg?style=for-the-badge

[contributors-url]: https://github.com/pavl21/GermanDactyl/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/pavl21/GermanDactyl.svg?style=for-the-badge

[forks-url]: https://github.com/pavl21/GermanDactyl/network/members

[stars-shield]: https://img.shields.io/github/stars/pavl21/GermanDactyl.svg?style=for-the-badge

[stars-url]: https://github.com/pavl21/GermanDactyl/stargazers

[issues-shield]: https://img.shields.io/github/issues/pavl21/GermanDactyl.svg?style=for-the-badge

[issues-url]: https://github.com/pavl21/GermanDactyl/issues

[license-shield]: https://img.shields.io/github/license/pavl21/GermanDactyl.svg?style=for-the-badge

[license-url]: https://github.com/pavl21/GermanDactyl/blob/master/LICENSE
