import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/utils/phone.dart';
import 'package:davidan_prototype/core/utils/time.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/models/rental_booking.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/total_bar.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/features/rental/application/rental_request_notifier.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_quote_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A car's request form, pushed from the car's page: where and when it is
/// picked up and returned, the extras, who to contact, and the price as
/// davidanrentcar.md's cart adds it up, following every change. The fields are
/// the site's "Cerere de rezervare" form's. Sending opens the sent request;
/// nothing is paid. The router only opens it for a car of the fleet.
class RentalRequestScreen extends ConsumerWidget {
  const RentalRequestScreen({super.key, required this.carId});

  final String carId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final car = ref.watch(rentalCarByIdProvider(carId))!;
    final draft = ref.watch(rentalRequestProvider(carId));
    RentalRequestNotifier form() =>
        ref.read(rentalRequestProvider(carId).notifier);
    final l10n = context.l10n;
    final quote = draft.datesValid
        ? quoteRental(car, days: draft.days, extras: draft.extras)
        : null;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: l10n.rentalRequestTitle,
              // Opened straight from a link, there's nothing to go back to.
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.rentalCar(carId)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                children: [
                  _CarSummary(car: car),
                  _Section(
                    title: l10n.rentalPickupTitle,
                    child: _PlaceAndTime(
                      location: draft.pickupLocation,
                      at: draft.pickupAt,
                      firstDate: draft.openedAt,
                      error: draft.pickupPassed
                          ? l10n.rentalPickupPassed
                          : null,
                      onLocationChanged: (location) =>
                          form().setPickupLocation(location),
                      onChanged: (at) => form().setPickupAt(at),
                    ),
                  ),
                  _Section(
                    title: l10n.rentalReturnTitle,
                    child: _PlaceAndTime(
                      location: draft.returnLocation,
                      at: draft.returnAt,
                      firstDate: draft.openedAt,
                      error: draft.returnNotAfterPickup
                          ? l10n.rentalReturnNotAfterPickup
                          : null,
                      onLocationChanged: (location) =>
                          form().setReturnLocation(location),
                      onChanged: (at) => form().setReturnAt(at),
                    ),
                  ),
                  _Section(
                    title: l10n.rentalExtrasTitle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final (index, extra) in RentalExtra.values.indexed)
                          Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 0 : AppSpacing.sm,
                            ),
                            child: _ExtraTile(
                              title: l10n.rentalExtra(extra),
                              price: switch (extra) {
                                RentalExtra.childSeat =>
                                  l10n.rentalPriceWholeRental(
                                    l10n.formatEuro(RentalTerms.childSeatEur),
                                  ),
                                RentalExtra.unlimitedKm =>
                                  l10n.rentalPricePerDay(
                                    l10n.formatEuro(
                                      RentalTerms.unlimitedKmPerDayEur,
                                    ),
                                  ),
                              },
                              selected: draft.extras.contains(extra),
                              onTap: () => form().toggleExtra(extra),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _Section(
                    title: l10n.rentalContactTitle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // The draft owns the text; the fields only read it
                        // when created.
                        TextFormField(
                          initialValue: draft.name,
                          onChanged: (name) => form().setName(name),
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          style: context.textStyles.body,
                          decoration: InputDecoration(
                            labelText: l10n.nameLabel,
                            prefixIcon: const Icon(PhosphorIconsRegular.user),
                            errorText: draft.showErrors && draft.nameMissing
                                ? l10n.nameMissing
                                : null,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          initialValue: draft.phone,
                          onChanged: (phone) => form().setPhone(phone),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [MoldovanPhone.inputFormatter],
                          style: context.textStyles.body,
                          decoration: InputDecoration(
                            labelText: l10n.phoneLabel,
                            hintText: l10n.phoneHint,
                            prefixText: '${MoldovanPhone.prefix} ',
                            prefixIcon: const Icon(
                              PhosphorIconsRegular.deviceMobile,
                            ),
                            errorText: draft.showErrors && !draft.phoneValid
                                ? l10n.phoneInvalid
                                : null,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          initialValue: draft.notes,
                          onChanged: (notes) => form().setNotes(notes),
                          minLines: 2,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          style: context.textStyles.body,
                          decoration: InputDecoration(
                            labelText: l10n.rentalNotesLabel,
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Section(
                    title: l10n.rentalQuoteTitle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (quote != null)
                          RentalQuoteCard(quote: quote)
                        else
                          InfoNote(
                            icon: PhosphorIconsRegular.calendarX,
                            text: draft.pickupPassed
                                ? l10n.rentalPickupPassed
                                : l10n.rentalReturnNotAfterPickup,
                          ),
                        const SizedBox(height: AppSpacing.md),
                        InfoNote(
                          icon: PhosphorIconsRegular.phoneCall,
                          text: l10n.rentalNoPaymentNote,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TotalBar(
        label: l10n.rentalPriceTotal,
        total: quote == null ? '–' : l10n.formatEuro(quote.priceEur),
        caption: quote == null
            ? null
            : l10n.rentalInsuranceExtra(l10n.formatEuro(quote.insuranceEur)),
        actionLabel: l10n.rentalSendRequest,
        onAction: () {
          final booking = form().send();
          if (booking != null) context.go(Routes.clientBooking(booking.id));
        },
      ),
    );
  }
}

/// The car being requested: its photo, name and main specs.
class _CarSummary extends StatelessWidget {
  const _CarSummary({required this.car});

  final RentalCar car;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          child: SizedBox(
            width: 84,
            height: 56,
            child: Image.asset(
              car.image,
              fit: BoxFit.cover,
              alignment: const Alignment(0, 0.5),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(car.name, style: context.textStyles.subtitle),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                ['${car.year}', car.gearbox, car.fuel].join(' · '),
                style: context.textStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A pickup's or return's place, as chips, and its date and time.
class _PlaceAndTime extends StatelessWidget {
  const _PlaceAndTime({
    required this.location,
    required this.at,
    required this.firstDate,
    required this.error,
    required this.onLocationChanged,
    required this.onChanged,
  });

  final RentalLocation location;
  final DateTime at;

  /// The earliest day the date picker offers.
  final DateTime firstDate;

  /// What is wrong with [at], or null.
  final String? error;
  final ValueChanged<RentalLocation> onLocationChanged;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final error = this.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppChip.runSpacing,
          children: [
            for (final place in RentalLocation.values)
              AppChip(
                label: context.l10n.rentalLocation(place),
                icon: switch (place) {
                  RentalLocation.airport => PhosphorIconsRegular.airplane,
                  RentalLocation.chisinau => PhosphorIconsRegular.buildings,
                },
                selected: place == location,
                onTap: () => onLocationChanged(place),
              ),
          ],
        ),
        // The chips' clear margin makes up the rest of the gap.
        const SizedBox(height: AppSpacing.md - AppChip.tapMargin),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DateField(
                date: at,
                firstDate: firstDate,
                hasError: error != null,
                onPicked: (date) => onChanged(
                  DateTime(date.year, date.month, date.day, at.hour, at.minute),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 124,
              child: _TimeField(
                time: at,
                onPicked: (minutes) => onChanged(
                  DateTime(
                    at.year,
                    at.month,
                    at.day,
                    minutes ~/ 60,
                    minutes % 60,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            error,
            style: context.textStyles.caption.copyWith(
              color: context.colors.error,
            ),
          ),
        ],
      ],
    );
  }
}

/// The date of [date], opening the date picker. Days before [firstDate] can't
/// be picked, nor more than a year after it.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.date,
    required this.firstDate,
    required this.hasError,
    required this.onPicked,
  });

  final DateTime date;
  final DateTime firstDate;
  final bool hasError;
  final ValueChanged<DateTime> onPicked;

  @override
  Widget build(BuildContext context) {
    final first = DateUtils.dateOnly(firstDate);
    final day = DateUtils.dateOnly(date);

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.md),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: day.isBefore(first) ? first : day,
          firstDate: first,
          lastDate: DateTime(first.year + 1, first.month, first.day),
          // Inside the phone frame, not over the whole browser window.
          useRootNavigator: false,
        );
        if (picked != null) onPicked(picked);
      },
      child: InputDecorator(
        isEmpty: false,
        decoration: InputDecoration(
          labelText: context.l10n.rentalDateLabel,
          prefixIcon: const Icon(PhosphorIconsRegular.calendarBlank),
          enabledBorder: hasError
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  borderSide: BorderSide(color: context.colors.error),
                )
              : null,
        ),
        child: Text(formatDate(date), style: context.textStyles.body),
      ),
    );
  }
}

/// The time of [time], chosen from every half hour of the day, as on
/// davidanrentcar.md's forms.
class _TimeField extends StatelessWidget {
  const _TimeField({required this.time, required this.onPicked});

  final DateTime time;

  /// Gets the minutes since midnight.
  final ValueChanged<int> onPicked;

  static const _step = 30;

  @override
  Widget build(BuildContext context) {
    final minutes = time.hour * 60 + time.minute;

    return DropdownButtonFormField<int>(
      // Recreated when the time changes elsewhere (a moved pickup moves the
      // return), since the field only reads its value when created.
      key: ValueKey(minutes),
      initialValue: minutes,
      isExpanded: true,
      menuMaxHeight: 320,
      style: context.textStyles.body,
      dropdownColor: context.colors.surface,
      icon: const Icon(PhosphorIconsBold.caretDown, size: 18),
      decoration: InputDecoration(labelText: context.l10n.rentalTimeLabel),
      items: [
        for (var slot = 0; slot < 24 * 60; slot += _step)
          DropdownMenuItem(
            value: slot,
            child: Text(
              formatTime(DateTime(2000, 1, 1, slot ~/ 60, slot % 60)),
            ),
          ),
      ],
      onChanged: (slot) {
        if (slot != null) onPicked(slot);
      },
    );
  }
}

/// An extra service with its price, ticked when chosen.
class _ExtraTile extends StatelessWidget {
  const _ExtraTile({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: selected,
      child: Material(
        color: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: selected
              ? BorderSide(color: context.colors.primary, width: 2)
              : BorderSide(color: context.colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(
                  selected
                      ? PhosphorIconsFill.checkSquare
                      : PhosphorIconsRegular.square,
                  size: 22,
                  color: selected
                      ? context.colors.primary
                      : context.colors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(title, style: context.textStyles.bodyStrong),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(price, style: context.textStyles.bodySecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: context.textStyles.subtitle),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
