$Env:EDITOR = 'nvim'
$Env:KOMOREBI_CONFIG_HOME = "$Env:USERPROFILE\.config\komorebi"
$Env:WHKD_CONFIG_HOME = "$Env:USERPROFILE\.config\whkd"
$Env:NVIM_APPNAME = 'MiniNvim'

# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Aliases
Set-Alias -Name so      -Value Source-PowerShell-Profile
Set-Alias -Name ls      -Value ShowDirectoryEza
Set-Alias -Name lst     -Value ShowDirectoryEzaTree
Set-Alias -Name gds			-Value get_directory_sizes

# Start Komorebi - Bar - WHKD
function ks{komorebic start --whkd --bar}
# Stop Komorebi - Bar - WHKD
function kst{komorebic stop --whkd --bar}
# Restart Komorebi - Bar - WHKD
function rswm{
    komorebic stop --whkd --bar
    komorebic start --whkd --bar
    }

# Edit PowerShell Profile
function epsp{nvim ($PROFILE.CurrentUserAllHosts)}
# Edit Neovim Config
function enc{
  cd "$Env:USERPROFILE\AppData\Local\nvim"
  nvim .
}
# Edit Git Config
function egc{nvim "$Env:USERPROFILE\.gitconfig"}
# Edit Komorebi Config
function ekom{nvim "$Env:USERPROFILE\.config\komorebi\komorebi.json"}
# Edit Komorebi Bar Config
function ekbar{nvim "$Env:USERPROFILE\.config\komorebi\komorebi.bar.json"}
# Edit WHKD Config
function ewhkd{nvim "$Env:USERPROFILE\.config\whkd\whkdrc"}
# Edit Wezterm Config
function ewez{nvim "$Env:USERPROFILE\.config\wezterm\wezterm.lua"}
# Edit PSReadline history
function epsh{nvim (Get-PSReadLineOption | select -ExpandProperty HistorySavePath)}
function gnc{fjira --project=GNC}
function ShowDirectoryEza{eza --icons=always --color=always --git -al --group-directories-first}
function ShowDirectoryEzaTree{eza --icons=always --color=always --git -al -T}
function gts {Set-Location "D:\source"}
function gtd {Set-Location "D:\data"}
function gh {Set-Location}
function Source-PowerShell-Profile {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.SendKeys]::SendWait(". $")
        [System.Windows.Forms.SendKeys]::SendWait("PROFILE.CurrentUserAllHosts")
        [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    }
function uenv {

		$Directory = Get-Location
    $OldPaneID = $Env:WEZTERM_PANE
    $NewPaneID = wezterm cli spawn --cwd $Directory
    wezterm cli activate-pane --pane-id $NewPaneID
    wezterm cli kill-pane --pane-id $OldPaneID
}
function workproxy {
				swap_proxy_settings -SetProxy 1
				uenv
		}
function homeproxy {
				swap_proxy_settings -SetProxy 0
				uenv
		}
function yy {
	$tmp = [System.IO.Path]::GetTempFileName()
	yazi $args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
		Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
	}
	Remove-Item -Path $tmp
}

function nvims()
{
  $items = "default", "MiniNvim"
  $config = $items | fzf --prompt=" Neovim Config 󰄾 " --height=~50% --layout=reverse --border --exit-0

  if ([string]::IsNullOrEmpty($config))
  {
    Write-Output "Nothing selected"
    break
  }

  if ($config -eq "default")
  {
    $config = ""
  }

  $env:NVIM_APPNAME=$config
  nvim $args
}

function nsf {nvims(fd -H -t f | fzf)}

function m21b {C:\MATLAB\R2021b\bin\matlab.exe}
function m24b {C:\MATLAB\R2024b\bin\matlab.exe}
function nf {nvim(fd -H -t f | fzf)}
function nd {nvim(fd -H -t d | fzf)}

function zd {
  $directory = fd -H -t d | fzf --prompt=" Search for path 󰄾 " --height=~50% --layout=reverse --border --exit-0

  if ([string]::IsNullOrEmpty($directory))
  {
    Write-Output "Nothing selected"
    break
  }

  z $directory

}

# Obsidian workflow
$Vault = "DishVault"
function oo   {Set-Location -Path ("$Env:USERPROFILE" + "\" + $Vault)}
function oib  {Set-Location -Path ("$Env:USERPROFILE" + "\" + $Vault + "\Inbox")}

. "$HOME\scripting\custom_prompt.ps1"
Invoke-Expression (& { (zoxide init powershell | Out-String) })
#Set-PSDebug -Trace 0
