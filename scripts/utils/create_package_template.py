import argparse
import logging
import os
import sys


# Set up logger
logging.basicConfig(
    format="%(asctime)s %(levelname)-8s [%(filename)s:%(lineno)d] %(message)s",
    level=logging.INFO,
    datefmt="%H:%M:%S",
    stream=sys.stderr,
)
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)


UNINSTALL_TEMPLATE_NAME = "chocolateyUninstall.ps1"
INSTALL_TEMPLATE_NAME = "chocolateyInstall.ps1"

"""
Needs the following format strings:
    pkg_name="...", version="...", authors="...", description="..."
"""
NUSPEC_TEMPLATE_NAME = "{}.vm.nuspec"
NUSPEC_TEMPLATE = r'''<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd">
  <metadata>
    <id>{pkg_name}.vm</id>
    <version>{version}</version>
    <authors>{authors}</authors>
    <description>{description}</description>
    <dependencies>
      <dependency id="common.vm" />
    </dependencies>
  </metadata>
</package>'''

"""
Needs the following format strings:
    tool_name="...", category="..."
"""
ZIP_INSTALL_TEMPLATE = r'''$ErrorActionPreference = 'Stop'
Import-Module VM.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

$zipUrl = ''
$zipSha256 = ''

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256'''

"""
Needs the following format strings:
    tool_name="...", category="..."
"""
GENERIC_UNINSTALL_TEMPLATE = r'''$ErrorActionPreference = 'Continue'
Import-Module VM.common -Force -DisableNameChecking

$toolName = '{tool_name}'
$category = '{category}'

VM-Uninstall $toolName $category
'''


def create_zip_template(packages_path,
                        pkg_name="",
                        version="",
                        authors="",
                        description="",
                        tool_name="",
                        category=""):
  pkg_path = os.path.join(packages_path, f"{pkg_name}.vm")
  try:
    os.makedirs(pkg_path)
  except:
    logger.debug(f"Directory already exists: {pkg_path}")

  tools_path = os.path.join(pkg_path, "tools")
  try:
    os.makedirs(tools_path)
  except:
    logger.debug(f"Directory already exists: {tools_path}")

  with open(os.path.join(pkg_path, NUSPEC_TEMPLATE_NAME.format(pkg_name)), 'w') as f:
    f.write(NUSPEC_TEMPLATE.format(pkg_name=pkg_name,
                                   version=version or "0.0.0",
                                   authors=authors,
                                   description=description))

  with open(os.path.join(tools_path, INSTALL_TEMPLATE_NAME), 'w') as f:
    f.write(ZIP_INSTALL_TEMPLATE.format(tool_name=tool_name, category=category))

  with open(os.path.join(tools_path, UNINSTALL_TEMPLATE_NAME), 'w') as f:
    f.write(GENERIC_UNINSTALL_TEMPLATE.format(tool_name=tool_name, category=category))


def get_script_directory():
  path = os.path.realpath(sys.argv[0])
  if os.path.isdir(path):
    return path
  else:
    return os.path.dirname(path)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="A CLI tool for bulk file downloads based on filemd5.")
  parser.add_argument("--pkg_name", type=str, required=True, help="Package name without suffix (i.e., no '.vm' needed)")
  parser.add_argument("--version", type=str, required=True, help="Tool's version number")
  parser.add_argument("--authors", type=str, required=True, help="Comma separated list of authors for tool")
  parser.add_argument("--tool_name", type=str, required=True, help="Name of tool (usually the file name with the '.exe')")
  parser.add_argument("--category", type=str, required=True, help="Category for tool")
  parser.add_argument("--description", type=str, required=False, help="Description for tool")
  args = parser.parse_args()

  root_dir = os.path.dirname(os.path.dirname(get_script_directory()))
  packages_path = os.path.join(root_dir, 'packages')
  create_zip_template(packages_path,
                      pkg_name=args.pkg_name,
                      version=args.version,
                      authors=args.authors,
                      tool_name=args.tool_name,
                      category=args.category,
                      description=args.description)
