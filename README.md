# Simple Health Check (PowerShell)

A short PowerShell script that checks the health of a Windows computer and
saves the results to `health_report.txt`.

## What it checks

- Computer name, operating system and last restart time
- Memory (RAM) usage
- Disk space for each drive
- Top 5 processes using the most CPU
- Automatic services that are stopped
- Whether the internet is reachable

It prints a warning if memory or a disk is more than 85% full.

## How to run

Open PowerShell in this folder and run:

```powershell
.\SimpleHealthCheck.ps1
```

If Windows blocks the script, run this first (it only applies to the current window):

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## What I practised

Variables, `if` statements, loops, the pipeline (`|`), and the cmdlets
`Get-Process`, `Get-Service`, `Get-PSDrive`, `Get-CimInstance` and
`Test-Connection`.
