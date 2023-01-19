class ContactRequestsController < ApplicationController
  after_action :mark_as_read, only: [:filtered_index]

  def filtered_index
    authorize ContactRequest.new
    blockages = find_blockages

    @contact_requests_sent = policy_scope(ContactRequest).includes(:sender, receiver: :avatar_attachment).where(sender: current_user, visible_sender: true).order(id: :desc).reject { |contact_request| blockages.include?(contact_request.receiver) || contact_request.receiver.banned? }.paginate(page: params[:page], per_page: 50)
    @contact_requests_received = policy_scope(ContactRequest).includes(sender: :avatar_attachment).where(receiver: current_user, visible_receiver: true).order(id: :desc).reject { |contact_request| blockages.include?(contact_request.sender) || contact_request.sender.banned? }.paginate(page: params[:page], per_page: 50)
    @nbr_new_contact_requests = policy_scope(ContactRequest).includes(:receiver).where(receiver: current_user, readed: false).size
  end

  def create
    receiver_id = contact_request_params["receiver_id"].to_i
    @receiver = User.find(receiver_id)

    @contact_request = ContactRequest.new
    @contact_request.sender = current_user
    @contact_request.receiver = @receiver
    authorize @contact_request

    if @contact_request.save
      CreateNotificationJob.perform_later(current_user, @receiver, helpers.notifications_contact_request)
      if @contact_request.receiver.notification_contact_request_received?
        NotificationMailer.with(receiver: @contact_request.receiver, sender: @contact_request.sender).contact_request_received.deliver_later
      end

      respond_to do |format|
        format.js
        format.html { redirect_back fallback_location: profil_path(@contact_request.receiver.slug), notice: "Votre demande de contact a bien été envoyé à #{@receiver.pseudo}." }
      end
    else
      redirect_back fallback_location: profil_path(@contact_request.receiver.slug), alert: "Erreur de saisie."
    end
  end

  def destroy
    @contact_request = authorize policy_scope(ContactRequest).find(params[:id])

    if @contact_request.accepted?
      redirect_back fallback_location: profil_path(@contact_request.receiver.slug), alert: 'Vous ne pouvez pas supprimer une demande de contact qui a été acceptée.'
    else
      @contact_request.destroy

      respond_to do |format|
        format.js
        format.html { redirect_back fallback_location: profil_path(@contact_request.receiver.slug), notice: 'Votre demande de contact a bien été supprimée.' }
      end
    end
  end

  def mark_as_accepted
    @contact_request = authorize policy_scope(ContactRequest).find(params[:id])

    if @contact_request.update(accepted: true)
      CreateNotificationJob.perform_later(@contact_request.receiver, @contact_request.sender, helpers.notifications_contact_request_accepted)
      if @contact_request.sender.notification_contact_request_accepted?
        NotificationMailer.with(receiver: @contact_request.receiver, sender: @contact_request.sender).contact_request_accepted.deliver_later
      end

      CreateChatroomJob.perform_later(@contact_request.sender, @contact_request.receiver)

      respond_to do |format|
        format.js
        format.html { redirect_back fallback_location: contact_requests_path, notice: "Vous venez d'accepter la demande de contact de #{@contact_request.sender.pseudo}." }
      end
    else
      redirect_back fallback_location: contact_requests_path, alert: "Une erreur est survenue."
    end
  end

  def hide_contact_request
    @contact_request = authorize policy_scope(ContactRequest).find(params[:id])

    if @contact_request.sender == current_user
      HideElementSenderJob.perform_later(@contact_request)
    elsif @contact_request.receiver == current_user
      HideElementReceiverJob.perform_later(@contact_request)
    end

    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: contact_requests_path, notice: 'La demande de contact a bien été cachée.' }
    end
  end

  private

  def contact_request_params
    params.require(:contact_request).permit(:receiver_id)
  end

  def mark_as_read
    contact_requests_received_not_readed = policy_scope(ContactRequest).where(receiver: current_user, readed: false)

    contact_requests_received_not_readed.each do |contact_request|
      MarkAsReadJob.perform_later(contact_request)
      CreateNotificationJob.perform_later(contact_request.receiver, contact_request.sender, helpers.notifications_contact_request_readed)
      if contact_request.sender.notification_contact_request_readed?
        NotificationMailer.with(receiver: contact_request.receiver, sender: contact_request.sender).contact_request_readed.deliver_later
      end
    end
  end
end
