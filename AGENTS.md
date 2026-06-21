# Repository Instructions

Start with `PROJECT.md` and `.doctrine/project.json` before changing this
repository. They define the project goal, lifecycle, boundaries, public
surfaces, delivery model, and adoption gaps.

Use `SylphxAI/doctrine` for enterprise standards. Keep this repository focused
on the Talos devmapper pool system extension: cluster-specific node policy,
Talos image composition, and consumer runtime rollout decisions belong in
downstream infrastructure repositories or documented configuration.

For control-plane-only changes, validate with:

```bash
python3 /Users/kyle/.doctrine/scripts/project-control-plane-audit.py --local . --fail-on-drift --json
git diff --check
```

For extension changes, also prove the Docker build, published image reference,
and Talos boot/runtime behavior affected by the change.
