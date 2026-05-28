import 'package:flutter/material.dart';
import 'dart:ui';

class ModuleTile extends StatelessWidget {
  const ModuleTile({
    super.key,
    required this.title,
    this.subtitle = '',
    this.iconAsset,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String? iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0x22FFFFFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0x66FFFFFF)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0x66FFFFFF),
                        border: Border.all(color: const Color(0xB3FFFFFF)),
                      ),
                      alignment: Alignment.center,
                      child: iconAsset == null
                          ? Image.asset(
                              'lib/images/icon/icon-default.png',
                              width: 42,
                              height: 42,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              iconAsset!,
                              width: 42,
                              height: 42,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                'lib/images/icon/icon-default.png',
                                width: 42,
                                height: 42,
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            shadows: const <Shadow>[
                              Shadow(color: Color(0x40000000), blurRadius: 4),
                            ],
                          ),
                    ),
                    if (subtitle.trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFFE9F1FF),
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
