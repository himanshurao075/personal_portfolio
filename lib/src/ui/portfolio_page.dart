import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key, required this.data});

  final PortfolioData data;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scrollController = ScrollController();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  late final Map<_SectionId, GlobalKey> _sectionKeys = {
    for (final id in _SectionId.values) id: GlobalKey(),
  };

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _companyController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(_SectionId id) async {
    final context = _sectionKeys[id]?.currentContext;
    if (context == null) {
      return;
    }

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  Future<void> _openUri(Uri uri) async {
    if (!await launchUrl(uri)) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the requested link.')),
      );
    }
  }

  Future<void> _submitContactForm() async {
    final basics = widget.data.basics;
    final subject = Uri.encodeComponent(
      'Portfolio enquiry from ${_nameController.text.trim().isEmpty ? 'a visitor' : _nameController.text.trim()}',
    );
    final body = Uri.encodeComponent('''
Name: ${_nameController.text.trim()}
Company: ${_companyController.text.trim()}
Contact: ${_contactController.text.trim()}
Email: ${_emailController.text.trim()}

Message:
${_messageController.text.trim()}
''');

    final uri = Uri.parse('mailto:${basics.email}?subject=$subject&body=$body');
    await _openUri(uri);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 760;
    final horizontalPadding = width < 700
        ? 18.0
        : width < 1200
        ? 32.0
        : 56.0;

    return Scaffold(
      drawer: isMobile ? _MobileDrawer(onSelected: _scrollTo) : null,
      bottomNavigationBar: isMobile
          ? _MobileBottomDock(onSelected: _scrollTo)
          : null,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9FBFF), Color(0xFFF7F2F2), Color(0xFFEAF3FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -160,
              left: -80,
              child: _GlowOrb(color: Color(0x55FF4A4A), size: 360),
            ),
            const Positioned(
              top: 120,
              right: -120,
              child: _GlowOrb(color: Color(0x55176BFF), size: 380),
            ),
            const Positioned(
              bottom: -140,
              left: 40,
              child: _GlowOrb(color: Color(0x33EE3A3A), size: 320),
            ),
            SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        16,
                        horizontalPadding,
                        0,
                      ),
                      child: _TopBar(
                        data: widget.data,
                        isMobile: isMobile,
                        onSectionTap: _scrollTo,
                        onOpenPhone: () => _openUri(
                          Uri.parse('tel:${widget.data.basics.phone}'),
                        ),
                        onOpenEmail: () => _openUri(
                          Uri.parse('mailto:${widget.data.basics.email}'),
                        ),
                        onOpenGithub: widget.data.basics.github.isEmpty
                            ? null
                            : () => _openUri(
                                Uri.parse(widget.data.basics.github),
                              ),
                        onOpenLinkedin: widget.data.basics.linkedin.isEmpty
                            ? null
                            : () => _openUri(
                                Uri.parse(widget.data.basics.linkedin),
                              ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        isMobile ? 96 : 32,
                      ),
                      child: Column(
                        children: [
                          _SectionAnchor(
                            key: _sectionKeys[_SectionId.home],
                            child: _Reveal(
                              delayMs: 0,
                              child: _HeroSection(
                                data: widget.data,
                                isMobile: isMobile,
                                onExplore: () => _scrollTo(_SectionId.projects),
                                onContact: () => _scrollTo(_SectionId.contact),
                              ),
                            ),
                          ),
                          _SectionAnchor(
                            key: _sectionKeys[_SectionId.about],
                            child: _Reveal(
                              delayMs: 100,
                              child: _AboutSection(
                                data: widget.data,
                                isMobile: isMobile,
                              ),
                            ),
                          ),
                          _SectionAnchor(
                            key: _sectionKeys[_SectionId.experience],
                            child: _Reveal(
                              delayMs: 160,
                              child: _ExperienceSection(data: widget.data),
                            ),
                          ),
                          _SectionAnchor(
                            key: _sectionKeys[_SectionId.projects],
                            child: _Reveal(
                              delayMs: 220,
                              child: _ProjectsSection(
                                data: widget.data,
                                isMobile: isMobile,
                              ),
                            ),
                          ),
                          _SectionAnchor(
                            key: _sectionKeys[_SectionId.certifications],
                            child: _Reveal(
                              delayMs: 280,
                              child: _CredentialsSection(
                                data: widget.data,
                                isMobile: isMobile,
                              ),
                            ),
                          ),
                          _SectionAnchor(
                            key: _sectionKeys[_SectionId.contact],
                            child: _Reveal(
                              delayMs: 340,
                              child: _ContactSection(
                                data: widget.data,
                                nameController: _nameController,
                                companyController: _companyController,
                                contactController: _contactController,
                                emailController: _emailController,
                                messageController: _messageController,
                                onSubmit: _submitContactForm,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _SectionId {
  home('Home'),
  about('About'),
  experience('Experience'),
  projects('Projects'),
  certifications('Credentials'),
  contact('Contact');

  const _SectionId(this.label);
  final String label;
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.data,
    required this.isMobile,
    required this.onSectionTap,
    required this.onOpenPhone,
    required this.onOpenEmail,
    required this.onOpenGithub,
    required this.onOpenLinkedin,
  });

  final PortfolioData data;
  final bool isMobile;
  final ValueChanged<_SectionId> onSectionTap;
  final VoidCallback onOpenPhone;
  final VoidCallback onOpenEmail;
  final VoidCallback? onOpenGithub;
  final VoidCallback? onOpenLinkedin;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Text(
            data.basics.name,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (!isMobile)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final item in _SectionId.values)
                  TextButton(
                    onPressed: () => onSectionTap(item),
                    child: Text(
                      item.label,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                IconButton.filledTonal(
                  onPressed: onOpenPhone,
                  icon: const Icon(Icons.call_outlined),
                ),
                IconButton.filledTonal(
                  onPressed: onOpenEmail,
                  icon: const Icon(Icons.mail_outline),
                ),
                if (onOpenGithub != null)
                  IconButton.filledTonal(
                    onPressed: onOpenGithub,
                    icon: const Icon(Icons.code_rounded),
                  ),
                if (onOpenLinkedin != null)
                  IconButton.filledTonal(
                    onPressed: onOpenLinkedin,
                    icon: const Icon(Icons.business_center_outlined),
                  ),
              ],
            )
          else
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({required this.onSelected});

  final ValueChanged<_SectionId> onSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            const ListTile(
              title: Text('Navigate'),
              subtitle: Text('Quick section jumps'),
            ),
            for (final item in _SectionId.values)
              ListTile(
                title: Text(item.label),
                onTap: () {
                  Navigator.of(context).pop();
                  onSelected(item);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileBottomDock extends StatelessWidget {
  const _MobileBottomDock({required this.onSelected});

  final ValueChanged<_SectionId> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: _GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _DockItem(
              icon: Icons.home_rounded,
              label: 'Home',
              onTap: () => onSelected(_SectionId.home),
            ),
            _DockItem(
              icon: Icons.person_outline_rounded,
              label: 'About',
              onTap: () => onSelected(_SectionId.about),
            ),
            _DockItem(
              icon: Icons.work_outline_rounded,
              label: 'Work',
              onTap: () => onSelected(_SectionId.projects),
            ),
            _DockItem(
              icon: Icons.mail_outline_rounded,
              label: 'Contact',
              onTap: () => onSelected(_SectionId.contact),
            ),
          ],
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.data,
    required this.isMobile,
    required this.onExplore,
    required this.onContact,
  });

  final PortfolioData data;
  final bool isMobile;
  final VoidCallback onExplore;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final basics = data.basics;
    if (isMobile) {
      return _MobileHeroSection(
        basics: basics,
        onExplore: onExplore,
        onContact: onContact,
      );
    }

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Badge(text: basics.experienceLabel),
        const SizedBox(height: 18),
        Text(
          basics.name,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          basics.headline,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          basics.tagline,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF445268)),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                basics.location,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(onPressed: onContact, child: const Text('Contact Me')),
            OutlinedButton(
              onPressed: onExplore,
              child: const Text('View Projects'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: basics.heroStats
              .map(
                (stat) => _MiniStatCard(label: stat.label, value: stat.value),
              )
              .toList(),
        ),
      ],
    );

    return _GlassPanel(
      padding: const EdgeInsets.all(28),
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: intro),
          const SizedBox(width: 24),
          const Expanded(flex: 5, child: _PortraitCard()),
        ],
      ),
    );
  }
}

class _MobileHeroSection extends StatelessWidget {
  const _MobileHeroSection({
    required this.basics,
    required this.onExplore,
    required this.onContact,
  });

  final Basics basics;
  final VoidCallback onExplore;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GlassPanel(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PortraitCard(compact: true),
              const SizedBox(height: 18),
              _Badge(text: basics.experienceLabel),
              const SizedBox(height: 14),
              Text(
                basics.name,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                basics.headline,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                basics.tagline,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF445268)),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(basics.location)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: onContact,
                      child: const Text('Contact'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onExplore,
                      child: const Text('Projects'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: basics.heroStats.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final stat = basics.heroStats[index];
              return SizedBox(
                width: 124,
                child: _MiniStatCard(label: stat.label, value: stat.value),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.data, required this.isMobile});

  final PortfolioData data;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'About, skills and services',
      subtitle: 'One JSON object powers this content, so updates stay simple.',
      child: Column(
        children: [
          _GlassPanel(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final paragraph in data.about) ...[
                  Text(paragraph),
                  const SizedBox(height: 14),
                ],
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: data.services
                      .map((service) => Chip(label: Text(service)))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _ResponsiveWrapGrid(
            minCardWidth: isMobile ? 280 : 340,
            maxColumns: isMobile ? 1 : 2,
            itemCount: data.skillGroups.length,
            itemBuilder: (context, index, cardWidth) {
              final group = data.skillGroups[index];
              return SizedBox(
                width: cardWidth,
                child: _GlassPanel(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        group.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: group.items
                            .map((item) => Chip(label: Text(item)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({required this.data});

  final PortfolioData data;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Professional experience',
      subtitle:
          'A timeline of product work across enterprise, B2B, and EdTech teams.',
      child: Column(
        children: data.experience
            .map(
              (item) => _GlassPanel(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFEE3A3A), Color(0xFF176BFF)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.role,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.company} • ${item.period}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.location,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: const Color(0xFF586579)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (final highlight in item.highlights)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('• $highlight'),
                      ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({required this.data, required this.isMobile});

  final PortfolioData data;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Selected projects',
      subtitle:
          'Representative case studies derived from your resume and role history.',
      child: Column(
        children: [
          _ResponsiveWrapGrid(
            minCardWidth: isMobile ? 280 : 320,
            maxColumns: isMobile ? 1 : 3,
            itemCount: data.projects.length,
            itemBuilder: (context, index, cardWidth) {
              final project = data.projects[index];
              return SizedBox(
                width: cardWidth,
                child: _GlassPanel(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Badge(text: project.category),
                      const SizedBox(height: 16),
                      Text(
                        project.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        project.summary,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: project.tech
                            .map((item) => Chip(label: Text(item)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          _GlassPanel(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Icon(Icons.design_services_outlined),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'The same Flutter codebase works as a mobile app and a web portfolio, with design, content, and navigation shared across platforms.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CredentialsSection extends StatelessWidget {
  const _CredentialsSection({required this.data, required this.isMobile});

  final PortfolioData data;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Education, certifications and recommendations',
      subtitle: 'Academic record, continuing education, and peer validation.',
      child: Column(
        children: [
          _ResponsiveWrapGrid(
            minCardWidth: isMobile ? 280 : 360,
            maxColumns: isMobile ? 1 : 2,
            itemCount: data.education.length,
            itemBuilder: (context, index, cardWidth) {
              final item = data.education[index];
              return SizedBox(
                width: cardWidth,
                child: _GlassPanel(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.institution,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(item.degree),
                      const SizedBox(height: 8),
                      Text(item.period),
                      const SizedBox(height: 8),
                      Text('Grade: ${item.grade}'),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          _GlassPanel(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key certifications',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                for (final item in data.certifications.take(10)) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.verified_outlined, size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${item.title} • ${item.issuer} • ${item.issued}${item.credentialId.isEmpty ? '' : ' • ID ${item.credentialId}'}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          _ResponsiveWrapGrid(
            minCardWidth: isMobile ? 280 : 360,
            maxColumns: isMobile ? 1 : 2,
            itemCount: data.recommendations.length,
            itemBuilder: (context, index, cardWidth) {
              final item = data.recommendations[index];
              return SizedBox(
                width: cardWidth,
                child: _GlassPanel(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.role,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF5B687B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('“${item.quote}”'),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({
    required this.data,
    required this.nameController,
    required this.companyController,
    required this.contactController,
    required this.emailController,
    required this.messageController,
    required this.onSubmit,
  });

  final PortfolioData data;
  final TextEditingController nameController;
  final TextEditingController companyController;
  final TextEditingController contactController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final availability = data.basics.availability;
    final activeModes = [
      if (availability.openToFullTime) 'Open to full-time roles',
      if (availability.openToFreelance) 'Available for freelance work',
      if (availability.openToConsulting) 'Open to consulting',
      ...availability.preferredModes,
    ];

    return _SectionShell(
      title: 'Contact and availability',
      subtitle:
          'A direct mailto-based lead form works on static hosting, including GitHub Pages.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 900;
          final detailsCard = _GlassPanel(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Let’s build something valuable.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: activeModes
                      .map((item) => Chip(label: Text(item)))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Text('Phone: ${data.basics.phone}'),
                const SizedBox(height: 8),
                Text('Email: ${data.basics.email}'),
                const SizedBox(height: 8),
                Text('Location: ${data.basics.location}'),
              ],
            ),
          );
          final formCard = _GlassPanel(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _Field(controller: nameController, label: 'Name'),
                const SizedBox(height: 14),
                _Field(controller: companyController, label: 'Company'),
                const SizedBox(height: 14),
                _Field(
                  controller: contactController,
                  label: 'Phone or WhatsApp',
                ),
                const SizedBox(height: 14),
                _Field(controller: emailController, label: 'Email'),
                const SizedBox(height: 14),
                _Field(
                  controller: messageController,
                  label: 'Tell me about the role or project',
                  maxLines: 5,
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: onSubmit,
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Send enquiry'),
                  ),
                ),
              ],
            ),
          );

          if (isCompact) {
            return Column(
              children: [detailsCard, const SizedBox(height: 18), formCard],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: detailsCard),
              const SizedBox(width: 18),
              Expanded(flex: 2, child: formCard),
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.65),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF546377),
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child, this.padding, this.margin});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.78),
            const Color(0xFFF9FBFF).withValues(alpha: 0.64),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33176BFF).withValues(alpha: 0.08),
            blurRadius: 38,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PortraitCard extends StatelessWidget {
  const _PortraitCard({this.compact = false});

  final bool compact;
  static const _profileAssetPath = 'assets/images/33.png';

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: compact ? 1.28 : 0.88,
      child: _GlassPanel(
        padding: const EdgeInsets.all(22),
        child: Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(_profileAssetPath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(1000),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0C1730),
                  Color(0xFF152B5E),
                  Color(0xFFB42835),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF59677A)),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFECEC), Color(0xFFEAF3FF)],
        ),
        border: Border.all(color: const Color(0x26EE3A3A)),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SectionAnchor extends StatelessWidget {
  const _SectionAnchor({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class _Reveal extends StatelessWidget {
  const _Reveal({required this.child, required this.delayMs});

  final Widget child;
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 650 + delayMs),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final offset = 28 * (1 - value);
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, offset), child: child),
        );
      },
      child: child,
    );
  }
}

class _ResponsiveWrapGrid extends StatelessWidget {
  const _ResponsiveWrapGrid({
    required this.itemCount,
    required this.itemBuilder,
    required this.minCardWidth,
    required this.maxColumns,
  });

  final int itemCount;
  final double minCardWidth;
  final int maxColumns;
  final Widget Function(BuildContext context, int index, double cardWidth)
  itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 18.0;
        final availableWidth = constraints.maxWidth;
        var columns = (availableWidth / minCardWidth).floor();
        columns = columns.clamp(1, maxColumns);
        final cardWidth = columns == 1
            ? availableWidth
            : (availableWidth - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var index = 0; index < itemCount; index++)
              itemBuilder(context, index, cardWidth),
          ],
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
