"""
Palimpsest License - Python/Flask Integration
"""

from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name="palimpsest-license",
    version="0.4.0",
    author="Palimpsest License Contributors",
    author_email="hello@palimpsestlicense.org",
    description="Python utilities for Palimpsest License integration",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/palimpsest-license/palimpsest-license",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "License :: Other/Proprietary License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
    ],
    python_requires=">=3.8",
    install_requires=[
        "Flask>=2.0.0",
    ],
    extras_require={
        "dev": [
            "pytest>=7.0.0",
            "black>=23.0.0",
            "mypy>=1.0.0",
            "flake8>=6.0.0",
        ],
        "django": ["Django>=3.2"],
        "fastapi": ["fastapi>=0.100.0"],
    },
    keywords="palimpsest license copyright ai-ethics flask python",
    project_urls={
        "Bug Reports": "https://github.com/palimpsest-license/palimpsest-license/issues",
        "Documentation": "https://palimpsestlicense.org",
        "Source": "https://github.com/palimpsest-license/palimpsest-license",
    },
)
